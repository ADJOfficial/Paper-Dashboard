//
//  FacultyDetails.swift
//  Director Dashboard
//
//  Created by ADJ on 13/01/2024.
//

import SwiftUI
//import GoogleMobileAds

struct FacultyDetails: View { // Designed 100% OK

    @State private var searchText = ""
    @StateObject private var facultiesViewModel = FacultiesViewModel()
    
    @Environment(\.presentationMode) var presentationMode

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
                Text("Faculty")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                //                Spacer()
                SearchBar(text: $searchText)
                    .padding()
                //                Spacer()
                VStack{
                    ScrollView {
                        ForEach(filteredFaculties.indices, id: \.self) { index in
                            let cr = filteredFaculties[index]
                            HStack{
                                Text(cr.f_name)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                
                                NavigationLink{
                                    EyeAssignedCousres(facultyID: cr.f_id, facultyName: cr.f_name)
                                        .navigationBarBackButtonHidden(true)
                                }label: {
                                    Image(systemName: "eye.fill")
                                        .bold()
                                        .font(.title3)
                                        .foregroundColor(Color.orange)
                                }
                                
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                        if filteredFaculties.isEmpty {
                            Text("No Faculty Found")
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
                        .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                )
                .frame(height:700)
                .onAppear {
                    facultiesViewModel.fetchExistingFaculties()
                }
                Spacer()
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fc") .resizable().ignoresSafeArea())
        }
    }
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
}

struct EyeAssignedCousres: View {  // Design 100% ok
    
    @StateObject private var assignedcoursesViewModel = AssignedCoursesViewModel()
    @StateObject private var activeSessionViewModel = ActiveSessionViewModel()
    
    var facultyID: Int
    var facultyName: String
    
    @State private var showDeleteAlert = false
    @State private var selectedCourse: (facultyId: Int, courseId: Int)?
    
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        NavigationView{
            VStack {
                Text("Assigned Courses")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("\(facultyName)")
                    .bold()
                    .padding()
                    .font(.title2)
                    .frame(maxWidth: .infinity , alignment: .center)
                    .foregroundColor(Color.teal)
                HStack{
                    Text("Assigned Courses")
                        .underline()
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    HStack{
                        Text(activeSessionViewModel.activeSessionName)
                            .font(.title2)
                            .foregroundColor(Color.green)
                        Text(activeSessionViewModel.activeSessionYear)
                            .font(.title2)
                            .foregroundColor(Color.yellow)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .trailing)
                    .onAppear {
                        activeSessionViewModel.getActiveSession()
                    }
                }
                VStack{
                    ScrollView{
                        ForEach(assignedcoursesViewModel.assignedCourses, id: \.self) { cr in
                            HStack{
                                Text(cr.c_title)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                Text(cr.c_code)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .center)
                                Image(systemName: "trash.fill")
                                    .font(.title3)
                                    .foregroundColor(Color.red)
                                    .onTapGesture {
                                        showDeleteAlert = true
                                        selectedCourse = (facultyId: cr.f_id, courseId: cr.c_id)
                                    }
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                        if assignedcoursesViewModel.assignedCourses.isEmpty {
                            Text("\(facultyName) have no Assigned Courses Yet !")
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
                        .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                )
                .frame(height: 500)
                .onAppear {
                    assignedcoursesViewModel.fetchAssignedCourses(facultyID: facultyID)
                }
                
                NavigationLink{
                    PlusAssignCourse(facultyID: facultyID, facultyName: facultyName)
                        .navigationBarBackButtonHidden(true)
                }label: {
                    Image(systemName: "plus.app.fill")
                        .bold()
                        .padding()
                        .font(.largeTitle)
                        .foregroundColor(Color.teal.opacity(0.9))
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity , alignment: .trailing)
                }
//                Spacer()
            }
            .alert(isPresented: $showDeleteAlert) {
                let courseTitle = assignedcoursesViewModel.assignedCourses.first { $0.c_id == selectedCourse?.courseId }?.c_title ?? ""
                    return Alert(
                    title: Text("Delete Course"),
                    message: Text("Are you sure you want to Delete Assigned Course \(courseTitle) For \(facultyName)"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Delete"), action: {
                        if let course = selectedCourse {
                            deleteAssignedCourse(facultyId: course.facultyId, courseId: course.courseId)
                        }
                    })
                )
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fc").resizable().ignoresSafeArea())
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
    private func deleteAssignedCourse(facultyId: Int, courseId: Int) {
        assignedcoursesViewModel.deleteAssignedCourse(facultyId: facultyId, courseId: courseId)
    }
}


struct PlusAssignCourse: View { // Design 100% ok
    
    @StateObject private var coursesViewModel = CoursesViewModel()
    @StateObject private var assignedcoursesViewModel = AssignedCoursesViewModel()
    @StateObject private var activeSessionViewModel = ActiveSessionViewModel()
    
    var facultyID: Int
//    var courseID: Int
    var facultyName: String
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCourses: Set<Int> = []
   
    var filteredcourse: [AllCourses] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return coursesViewModel.existing
        } else {
            return coursesViewModel.existing.filter { faculty in
                faculty.c_code.localizedCaseInsensitiveContains(searchText) ||
                faculty.c_title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    struct SearchBar: View { // Search Bar avaible outside of table to search record
        
        @Binding var text: String
        
        var body: some View {
            HStack {
//                Spacer()
                TextField("Search", text: $text)
                    .padding()
                    .frame(width: 247 , height: 40)
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8) // Set the corner radius to round the corners
                    .padding(.horizontal)

                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color.red.opacity(0.9))
                }
                .opacity(text.isEmpty ? 0 : 1)
                Spacer()
            }
        }
    }
    
    var body: some View { // Get All Data From Node MongoDB : Pending
       
        VStack {
            Text("Assign Course")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
                Text("\(facultyName)")
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(Color.teal)
                Text("Subject")
                    .padding()
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                SearchBar(text: $searchText)
            Spacer()
            HStack{
                Text(activeSessionViewModel.activeSessionName)
                    .font(.title2)
                    .foregroundColor(Color.green)
                Text(activeSessionViewModel.activeSessionYear)
                    .font(.title2)
                    .foregroundColor(Color.yellow)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity , alignment: .trailing)
            .onAppear {
                activeSessionViewModel.getActiveSession()
            }
            VStack{
                ScrollView{
                    ForEach(filteredcourse, id: \.self) { cr in
                        HStack{
                            Text(cr.c_title)
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            VStack{
                                Button(action: {
                                    toggleCourseSelection(courseID: cr.c_id)
                                    assignCourseToFaculty(courseID: cr.c_id, facultyID: facultyID)
                                    selectedCourses.insert(cr.c_id)
                                }) {
                                    Image(systemName: selectedCourses.contains(cr.c_id) ? "checkmark.square.fill" : "square")
                                        .font(.title2)
                                        .foregroundColor(selectedCourses.contains(cr.c_id) || assignedcoursesViewModel.isCourseAssigned(courseID: cr.c_id) ? Color.teal : Color.white)
                                        .padding(.horizontal)
                                }
                                .disabled(selectedCourses.contains(cr.c_id) || assignedcoursesViewModel.isCourseAssigned(courseID: cr.c_id))
                                .opacity(selectedCourses.contains(cr.c_id) || assignedcoursesViewModel.isCourseAssigned(courseID: cr.c_id) ? 0.9 : 1.0)
                                .onAppear {
                                    if assignedcoursesViewModel.isCourseAssigned(courseID: cr.c_id) {
                                        selectedCourses.insert(cr.c_id)
                                    }
                                }
                            }
                        }
                        Divider()
                            .background(Color.white)
                            .padding(1)
                    }
                    if filteredcourse.isEmpty {
                        Text("No Course Found")
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
                    .stroke(Color.blue.opacity(0.6), lineWidth: 2)
            )
            .frame(height: 500)
            .onAppear {
                coursesViewModel.fetchExistingCourses()
                assignedcoursesViewModel.fetchAssignedCourses(facultyID: facultyID)
            }
            Spacer()
            
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fc").resizable().ignoresSafeArea())
    }
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
    private func toggleCourseSelection(courseID: Int) {
           if selectedCourses.contains(courseID) {
               selectedCourses.remove(courseID)
           } else {
               selectedCourses.insert(courseID)
           }
       }
    private func assignCourseToFaculty(courseID: Int, facultyID: Int) {
        let url = URL(string: "http://localhost:2000/assigncoursetofaculty")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "f_id": facultyID,
            "c_id": courseID
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                // Handle the error as needed
                return
            }
            
            guard let data = data else {
                print("No data received")
                // Handle the absence of data as needed
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        print(message)
                        // Update the UI or perform any other action based on the message
                    }
                } else {
                    print("Invalid JSON response")
                    // Handle the invalid JSON response as needed
                }
            } catch {
                print("Error parsing JSON response: \(error)")
                // Handle the JSON parsing error as needed
            }
        }.resume()
    }
}

struct FacultyDetails_Previews: PreviewProvider {
    static var previews: some View {
        FacultyDetails()
    }
}

