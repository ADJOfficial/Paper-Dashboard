//
//  AssignRole.swift
//  Director Dashboard
//
//  Created by ADJ on 20/01/2024.
//

import SwiftUI


struct AssignRole: View {

    @State private var selectedCourse: AllCourses?
    @State private var selectedFaculty: Courer?
    @StateObject private var coursesViewModel = CoursesViewModel()
    @StateObject private var coViewModel = CoViewModel()

    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Assign Role")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            
            Spacer()
            
            Text("Course")
                .bold()
                .padding()
                .padding(.horizontal)
                .font(.title)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack {
                Picker(selection: $selectedCourse, label: Text("")) {
                    Text("Courses").tag(nil as AllCourses?)
                    ForEach(coursesViewModel.existing, id: \.c_id) { course in
                        Text(course.c_title)
                            .tag(course as AllCourses?)
                    }
                }
                .accentColor(Color.green)
                .onChange(of: selectedCourse) { selectedCourse in
                    if let selectedCourse = selectedCourse {
                        print("Selected Course ID: \(selectedCourse.c_id)")
                        fetchAssignedFaculty()
                    }
                }
            }
            
            Spacer()
            
            VStack{
                if let selectedCourse = selectedCourse {
                    if coViewModel.Courseassignedto.isEmpty {
                        Text("No faculty assigned to Course \(selectedCourse.c_title)")
                            .foregroundColor(Color.white)
                            .padding()
                    } else {
                        ScrollView {
                            ForEach(coViewModel.Courseassignedto, id: \.self) { assignedFaculty in
                                Button(action: {
                                    updateFacultyRole(selectedFaculty: assignedFaculty)
                                }) {
                                    HStack {
                                        Text(assignedFaculty.f_name)
                                            .bold()
                                            .font(.title3)
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Image(systemName: selectedFaculty?.f_id == assignedFaculty.f_id ? "largecircle.fill.circle" : "circle")
                                            .font(.title3)
                                            .foregroundColor(Color.green)
                                    }
                                }
                                .padding()
                                .onAppear {
                                    if assignedFaculty.role == "Senior" {
                                        selectedFaculty = assignedFaculty
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                        )
                        .frame(height: 350)
                    }
                } else {
                    Text("No course selected")
                        .foregroundColor(Color.white)
                        .padding()
                        .padding(.horizontal)
                }
            }
            .onAppear {
                coursesViewModel.fetchExistingCourses()
            }
            
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Congratulations"), message: Text("Faculty ** Updated Successfully"), dismissButton: .default(Text("OK")))
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fc").resizable().ignoresSafeArea())
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
    
    func fetchAssignedFaculty() {
        coViewModel.Courseassignedto.removeAll()
        if let courseID = selectedCourse?.c_id {
            coViewModel.fetchCoursesAssignedTo(courseID: courseID)
        }
    }

    func updateFacultyRole(selectedFaculty: Courer?) {
        guard let selectedCourseID = selectedCourse?.c_id, let selectedFacultyID = selectedFaculty?.f_id else {
            return
        }

        let url = URL(string: "http://localhost:2000/updatefacultyrole")!

        // Create the request body
        let requestBody: [String: Any] = [
            "c_id": selectedCourseID,
            "f_id": selectedFacultyID
        ]

        // Convert the request body to JSON data
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Parse the response data
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = json as? [String: Any], let message = responseDict["message"] as? String {
                    print(message)
                    DispatchQueue.main.async {
                        self.selectedFaculty = selectedFaculty
                    }
                }
            } catch {
                print("Error parsing response: \(error)")
            }
        }.resume()
    }
}

struct AssignRole_Previews: PreviewProvider {
    static var previews: some View {
        AssignRole()
    }
}
