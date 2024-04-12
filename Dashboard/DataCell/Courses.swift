//
//  Faculty.swift
//  Director Dashboard
//
//  Created by ADJ on 13/01/2024.
//

import SwiftUI

struct Course: View {   // Design 100% OK

    @State private var showAlert = false
    @State private var createdCourse = ""
    
    @State private var c_code = ""
    @State private var c_title = ""
    @State private var cr_hours = ""
    
    @State private var isCodeEmpty = false
    @State private var isTitleEmpty = false
    @State private var isHoursEmpty = false
    
    @State private var searchText = ""
    @StateObject private var coursesViewModel = CoursesViewModel()

    var filteredCourses: [AllCourses] { // All Data Will Be Filter and show on Table
            if searchText.isEmpty {
                return coursesViewModel.existing
            } else {
                let filtered = coursesViewModel.existing.filter { course in
                    course.c_code.localizedCaseInsensitiveContains(searchText) ||
                    course.c_title.localizedCaseInsensitiveContains(searchText)
                }
                return filtered.isEmpty ? [] : filtered
            }
        }

    struct SearchBar: View { // Search Bar avaible outside of table to search record
        @Binding var text: String

        var body: some View {
            HStack {
                TextField("Search Course", text: $text)
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
                Text("Create Course")
                    .padding()
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                
                Text("Course Code")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                VStack{
                    if isCodeEmpty {
                        Text("Required*")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity , alignment: .trailing)
                    }
                    TextField("Course Code" , text: $c_code)
                        .padding()
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .onChange(of: c_code) { newValue in
                    isCodeEmpty = newValue.isEmpty
                }
                
                Text("Course Title")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                VStack{
                    if isCodeEmpty {
                        Text("Required*")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity , alignment: .trailing)
                    }
                    TextField("Course Title" , text: $c_title)
                        .padding()
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                }
                .onChange(of: c_title) { newValue in
                    isTitleEmpty = newValue.isEmpty
                }
                
                Text("Credit Hours")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                VStack{
                    if isCodeEmpty {
                        Text("Required*")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity , alignment: .trailing)
                    }
                    TextField("Credit Hours" , text: $cr_hours)
                        .padding()
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                }
                .onChange(of: cr_hours) { newValue in
                    isHoursEmpty = newValue.isEmpty
                }
                
                VStack{
                    Spacer()
                    Button("Create "){
                        validateAndCreateCourse()
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
                        ForEach(filteredCourses.indices, id: \.self) { index in
                            let cr = filteredCourses[index]
                            HStack{
                                Text(cr.c_title)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                Text(cr.c_code)
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .center)

                                NavigationLink {
                                    EditCourse(course: cr)
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
                        if filteredCourses.isEmpty {
                            Text("No Course Found")
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
                    coursesViewModel.fetchExistingCourses()
                }
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Course Created"), message: Text("Course \(createdCourse) has been Created Successfully"), dismissButton: .default(Text("OK")))
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
        return filteredCourses[index].status == "enable"
    }
    func toggleFacultyStatus(_ index: Int) {
        let course = filteredCourses[index]
        let newStatus = course.status == "enable" ? "disable" : "enable"

        guard let url = URL(string: "http://localhost:8000/enabledisablecourse/\(course.c_id)") else {
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
                    print("Course status updated successfully: \(responseString)")
                    coursesViewModel.fetchExistingCourses()
                }
            }
        }.resume()
    }
    
    func validateAndCreateCourse() {
        isCodeEmpty = c_code.isEmpty
        isTitleEmpty = c_title.isEmpty
        isHoursEmpty = cr_hours.isEmpty
        
        if !isCodeEmpty && !isTitleEmpty && !isHoursEmpty {
            createCourse()
        }
    }
    func createCourse() {
        guard let url = URL(string: "http://localhost:8000/addnewcourse") else {
            return
        }

        let user = [
            "c_code": c_code,
            "c_title": c_title,
            "cr_hours": cr_hours
        ] as [String : Any]
        createdCourse = c_title
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
                    coursesViewModel.fetchExistingCourses() // Refresh faculties after creating a new one
                    DispatchQueue.main.async {
                        showAlert = true
                        c_code = ""
                        c_title = ""
                        cr_hours = ""
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


struct EditCourse: View { // Design 100% OK
    
    var course: AllCourses
    @State private var c_code = ""
    @State private var c_title = ""
    @State private var cr_hours = 0
    
    @State private var updatedCourseName = ""
    @State private var showAlert = false
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        VStack {
            Text("Update Course")
                .padding()
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            Text("Course Code")
                .bold()
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            TextField("Course Code" , text: $c_code)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
                .onAppear {
                    c_code = course.c_code
                }
            Text("Course Title")
                .bold()
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            TextField("Course Title" , text: $c_title)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
                .onAppear {
                    c_title = course.c_title
                }
            Text("Credit Hours")
                .bold()
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            TextField("Credit Hours" , value: $cr_hours, formatter: NumberFormatter())
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
                .onAppear {
                    cr_hours = course.cr_hours
                }
            Spacer()
            Button("Update"){
                updateCourse()
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
            Alert(title: Text("Congratulations"), message: Text("Course *\(updatedCourseName)* has been Updated Successfully"), dismissButton: .default(Text("OK")))
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
    func updateCourse() {
        guard let url = URL(string: "http://localhost:8000/updatecourse/\(course.c_id)") else {
            return
        }
        
        let updatedCourse = AllCourses(c_id: course.c_id, c_code: c_code, c_title: c_title, cr_hours: cr_hours, status: course.status)
        updatedCourseName = c_title
        guard let encodedData = try? JSONEncoder().encode(updatedCourse) else {
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
                if let message = responseJSON?["message"] as? String, message == "Course record updated successfully" {
                    print("Course updated successfully")
                    showAlert = true
                } else {
                    print("Error: Course record not updated")
                }
            } catch {
                print("Error while decoding response data: \(error)")
            }
        }
        task.resume()
    }
}
struct Courses_Previews: PreviewProvider {
    static var previews: some View {
        Course()
    }
}



