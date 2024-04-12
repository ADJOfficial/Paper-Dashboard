//
//  ViewCLOs.swift
//  Director Dashboard
//
//  Created by ADJ on 14/01/2024.
//

import SwiftUI

struct ViewCLOs: View { // Design 100% Ok
    
    
    var f_id: Int
    var c_id: Int
    var c_title: String
//    var clo_id: Int
//    var clo_text: String
    
    @State private var clo_code = ""
    @State private var clo_text = ""
    @State private var searchText = ""
    @StateObject private var cloViewModel = CLOViewModel()
    
    @State private var showAlert = false
    
    var filteredClo: [CLO] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return cloViewModel.existing
        } else {
            return cloViewModel.existing.filter { topic in
                topic.clo_text.localizedCaseInsensitiveContains(searchText)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color.red.opacity(0.9))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .opacity(text.isEmpty ? 0 : 1)
            }
        }
    }
    
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        NavigationView {
            VStack {
                Text("CLO")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("Course")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                Text("\(c_title)")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity , alignment: .center)
                    .foregroundColor(Color.white)
                VStack {
                    Text("CLO-Code")
                        .padding(.horizontal)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("Enter CLO Code" , text: $clo_code)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    Text("Desccription")
                        .padding(.horizontal)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("Enter CLO Description" , text: $clo_text)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Image(systemName: "bolt.fill")
                        .padding()
                        .font(.largeTitle)
                        .foregroundColor(Color.green)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity , alignment: .trailing)
                        .onTapGesture {
                            createCLO()
                            showAlert
                        }
                }
                SearchBar(text: $searchText)
                    .padding()
                
                VStack {
                    ScrollView{
                        ForEach(filteredClo.indices , id:\ .self) { index in
                            let cr = filteredClo[index]
                            HStack{
                                Text(cr.clo_text)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                NavigationLink{
                                    EditCLO(f_id: f_id, c_id: c_id, c_title: c_title, clo: cr)
//                                        .navigationBarBackButtonHidden(true)
                                }label: {
                                    Image(systemName: "square.and.pencil.circle")
                                        .font(.title)
                                        .foregroundColor(Color.orange)
                                        .frame(maxWidth: .infinity , alignment: .trailing)
                                }
                                Image(systemName: isCloEnabled(index) ? "checkmark.circle.fill" : "nosign")
                                    .font(.title)
                                    .foregroundColor(isCloEnabled(index) ? .green : .red)
                                    .onTapGesture {
                                        toggleCloStatus(index)
                                    }
                            }
                            Divider()
                                .background(Color.white)
                            .padding(1)
                        }
                        if filteredClo.isEmpty {
                            Text("No CLO Found For Course - \(c_title)")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.5), lineWidth: 2)
                )
                .frame(height:300)
                .onAppear {
                    cloViewModel.getCourseCLO(courseID: c_id)
                }
                
            }
            .background(Image("fiii").resizable().ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Congratulations"), message: Text("CLO Created Successfully"), dismissButton: .default(Text("OK")))
            }
        }
    }

    func createCLO() {
        guard let url = URL(string: "http://localhost:4000/addCLO") else {
            return
        }

        let user = [
            "c_id": c_id,
            "clo_code": clo_code,
            "clo_text": clo_text
        ] as [String : Any]

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
                    cloViewModel.getCourseCLO(courseID: c_id) // Refresh faculties after creating a new one
                    showAlert = true
                    DispatchQueue.main.async {
                        clo_code = ""
                        clo_text = ""
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }
    
    func isCloEnabled(_ index: Int) -> Bool {
        return filteredClo[index].enabledisable == "Enable"
    }
    func toggleCloStatus(_ index: Int) {
        let topic = filteredClo[index]
        let newStatus = topic.enabledisable == "Enable" ? "Disable" : "Enable"
        
        guard let url = URL(string: "http://localhost:4000/enabledisableclo/\(topic.clo_id)") else {
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(["enabledisable": newStatus]) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating Topic status: \(error.localizedDescription)")
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("CLO status updated successfully: \(responseString)")
                    cloViewModel.getCourseCLO(courseID: c_id)
                }
            }
        }.resume()
    }
}

struct EditCLO: View { // Design 100% Ok
    
    var f_id: Int
    var c_id: Int
    var c_title: String
    
    var clo: CLO
   
    @State private var clo_code = ""
    @State private var clo_text = ""
    @StateObject private var cloViewModel = CLOViewModel()
    
    @State private var showAlert = false
    
    var body: some View { // Get All Data From Node MongoDB : Pending
       
        NavigationView {
            VStack {
                Text("Update CLO")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("Course")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                Text("\(c_title)")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity , alignment: .center)
                    .foregroundColor(Color.white)
                Text("CLO-Code")
                    .padding(.horizontal)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                TextField("Enter CLO Description" , text: $clo_code)
                    .padding()
                    .foregroundColor(Color.black)
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onAppear {
                        clo_code = clo.clo_code
                    }
                Text("Desccription")
                    .padding(.horizontal)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                TextField("Enter CLO Description" , text: $clo_text)
                    .padding()
                    .foregroundColor(Color.black)
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onAppear {
                        clo_text = clo.clo_text
                    }
                Spacer()
                Button("Update"){
                    updateClo()
                    showAlert
                }
                .bold()
                .padding()
                .frame(width: 150)
                .foregroundColor(.black)
                .background(Color.green)
                .cornerRadius(8)
                .padding(.all)
            }
            .background(Image("fiii").resizable().ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Congratulations"), message: Text("CLO Updated Successfully"), dismissButton: .default(Text("OK")))
            }
        }
    }
    func updateClo() {
        guard let url = URL(string: "http://localhost:4000/updateanyclo/\(clo.clo_id)") else {
            return
        }

        let updatedSubtopic = CLO(clo_id: clo.clo_id,clo_code: clo_code, clo_text: clo_text, status: clo.status, enabledisable: clo.enabledisable)

        guard let encodedData = try? JSONEncoder().encode(updatedSubtopic) else {
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
                    if let message = responseJSON?["message"] as? String, message == "CLO record updated successfully" {
                        print("CLO updated successfully")
                        showAlert = true
                    } else {
                        print("Error: CLO record not updated")
                    }
                } catch {
                    print("Error while decoding response data: \(error)")
                }
        }
        task.resume()
    }
}


struct ViewCLOs_Previews: PreviewProvider {
    static var previews: some View {
        ViewCLOs(f_id: 0, c_id: 3, c_title: "")
    }
}
