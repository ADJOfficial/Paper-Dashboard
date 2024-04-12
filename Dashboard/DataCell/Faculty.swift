//
//  Faculty.swift
//  Director Dashboard
//
//  Created by ADJ on 13/01/2024.
//

import SwiftUI

struct Faculty: View {   // Design 100% OK

    @State private var showAlert = false
    @State private var createdFaculty = ""

    @State private var f_name = ""
    @State private var username = ""
    @State private var password = ""
    
    @State private var isf_nameEmpty = false
    @State private var isusernameEmpty = false
    @State private var ispasswordEmpty = false
    
    @State private var searchText = ""
    @State private var searchResults: [faculties] = []
    @StateObject private var facultiesViewModel = FacultiesViewModel()

    var filteredFaculties: [faculties] { // All Data Will Be Filter and show on Table
            if searchText.isEmpty {
                return facultiesViewModel.remaining
            } else {
                return facultiesViewModel.remaining.filter { faculty in
                    faculty.f_name.localizedCaseInsensitiveContains(searchText) ||
                    faculty.username.localizedCaseInsensitiveContains(searchText)
                }
            }
        }

    struct SearchBar: View { // Search Bar avaible outside of table to search record
        @Binding var text: String

        var body: some View {
            HStack {
                TextField("Search", text: $text)
                    .padding()
                    .frame(width: 247 , height: 40)
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8) // Set the corner radius to round the corners
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color.red.opacity(0.9))
                }
                .opacity(text.isEmpty ? 0 : 1)
            }
        }
    }
    var body: some View { // Get All Data From Node MongoDB : Pending
        NavigationView {
            VStack {
                Text("Create Faculty")
                    .padding()
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Text("Name")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                VStack{
                    if isf_nameEmpty {
                        Text("Required*")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity , alignment: .trailing)
                    }
                    TextField("Name" , text: $f_name)
                        .padding()
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .onChange(of: f_name) { newValue in
                    isf_nameEmpty = newValue.isEmpty
                }
                Text("Username")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                VStack{
                    if isusernameEmpty {
                        Text("Required*")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity , alignment: .trailing)
                    }
                    TextField("Username" , text: $username)
                        .padding()
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .onChange(of: username) { newValue in
                    isusernameEmpty = newValue.isEmpty
                }
                Text("Password")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                VStack{
                    if ispasswordEmpty {
                        Text("Required*")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity , alignment: .trailing)
                    }
                    SecureField("Password" , text: $password)
                        .padding()
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .onChange(of: password) { newValue in
                    ispasswordEmpty = newValue.isEmpty
                }
                VStack{
                    Spacer()
                    Button("Create"){
                        validateAndCreateFaculty()
                    }
                    .bold()
                    .padding()
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .background(Color.yellow)
                    .cornerRadius(8)
                    SearchBar(text: $searchText)
                        .padding()
                }

                VStack{
                    ScrollView {
                        ForEach(filteredFaculties.indices, id: \.self) { index in
                            let cr = filteredFaculties[index]
                            HStack{
                                Text(cr.f_name)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                Text(cr.username)
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .center)
                                
                                NavigationLink {
                                    EditFaculty(faculty: cr)
                                        .navigationBarBackButtonHidden(true)
                                } label:{
                                    Image(systemName: "square.and.pencil.circle")
                                        .bold()
                                        .font(.title)
                                        .foregroundColor(Color.orange)
                                }
                                Image(systemName: isFacultyEnabled(index) ? "checkmark.circle.fill" : "nosign")
                                    .font(.title)
                                    .foregroundColor(isFacultyEnabled(index) ? .green : .red)
                                    .onTapGesture {
                                        toggleFacultyStatus(index)
                                    }
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                        if filteredFaculties.isEmpty {
                            Text("No Faculty Found")
                                .bold()
                                .font(.headline)
                                .foregroundColor(.orange)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                )
                .frame(height:250)
                .onAppear {
                    facultiesViewModel.fetchExistingFaculties()
                }
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Faculty Created"), message: Text("Faculty \(createdFaculty) has been Created Successfully"), dismissButton: .default(Text("OK")))
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fw").resizable().ignoresSafeArea())
        }
    }
    @Environment(\.presentationMode) var presentationMode
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
    func isFacultyEnabled(_ index: Int) -> Bool {
        return filteredFaculties[index].status == "enable"
    }
    func toggleFacultyStatus(_ index: Int) {
        let faculty = filteredFaculties[index]
        let newStatus = faculty.status == "enable" ? "disable" : "enable"
        
        guard let url = URL(string: "http://localhost:8000/enabledisablefaculty/\(faculty.f_id)") else {
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(["status": newStatus]) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating faculty status: \(error.localizedDescription)")
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Faculty status updated successfully: \(responseString)")
                    facultiesViewModel.fetchExistingFaculties()
                }
            }
        }.resume()
    }
    
    func validateAndCreateFaculty() {
        isf_nameEmpty = f_name.isEmpty
        isusernameEmpty = username.isEmpty
        ispasswordEmpty = password.isEmpty
        
        if !isf_nameEmpty && !isusernameEmpty && !ispasswordEmpty {
            createFaculty()
        }
    }
    func createFaculty() {
        guard let url = URL(string: "http://localhost:8000/addnewfaculty") else {
            return
        }

        let user = [
            "f_name": f_name,
            "username": username,
            "password": password
        ] as [String : Any]
        createdFaculty = f_name
        guard let jsonData = try? JSONSerialization.data(withJSONObject: user) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data)
                    print("Result from server:", result)
                    facultiesViewModel.fetchExistingFaculties() // Refresh faculties after creating a new one
                    DispatchQueue.main.async {
                        showAlert = true
                        f_name = ""
                        username = ""
                        password = ""
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }
}


struct EditFaculty: View { // Design 100% OK
    
    var faculty: faculties
    @State private var f_name = ""
    @State private var username = ""
    @State private var password = ""
    
    @State private var updatedFacultyName = ""
    @State private var showAlert = false
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        VStack {
            Text("Update Faculty")
                .padding()
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            Text("Name")
                .bold()
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            TextField("Name" , text: $f_name)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
                .onAppear {
                    f_name = faculty.f_name
                }
            Text("Username")
                .bold()
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            TextField("Username" , text: $username)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
                .onAppear {
                    username = faculty.username
                }
            Text("Password")
                .bold()
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            TextField("Password" , text: $password)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
                .onAppear {
                    password = faculty.password
                }
            Spacer()
            Button("Update"){
                updateFaculty()
            }
            .bold()
            .padding()
            .frame(width: 150)
            .foregroundColor(.black)
            .background(Color.yellow)
            .cornerRadius(8)
            .padding(.all)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Congratulations"), message: Text("Faculty *\(updatedFacultyName)* Updated Successfully"), dismissButton: .default(Text("OK")))
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fw").resizable().ignoresSafeArea())
    }
    @Environment(\.presentationMode) var presentationMode
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
    
    func updateFaculty() {
        guard let url = URL(string: "http://localhost:8000/updatefaculty/\(faculty.f_id)") else {
            return
        }

        let updatedFaculty = faculties(f_id: faculty.f_id, f_name: f_name, username: username , password: password ,status: faculty.status)
        updatedFacultyName = f_name
        guard let encodedData = try? JSONEncoder().encode(updatedFaculty) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error while updating subtopic: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")

            do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let message = responseJSON?["message"] as? String, message == "Faculty record updated successfully" {
                        print("Faculty updated successfully")
                        showAlert = true
                    } else {
                        print("Error: Faculty record not updated")
                    }
                } catch {
                    print("Error while decoding response data: \(error)")
                }
        }
        task.resume()
    }
}
struct Faculty_Previews: PreviewProvider {
    static var previews: some View {
        Faculty()
    }
}
