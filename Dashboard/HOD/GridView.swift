//
//  GridView.swift
//  Director Dashboard
//
//  Created by ADJ on 13/01/2024.
//

import SwiftUI

struct GridView: View { // Design 100% ok
    
    @State private var selectedCourse: AllCourses?
    @State private var selectedCLOCode: CLO?
    
    @State private var weight1 = ""
    @State private var weight2 = ""
    @State private var weight3 = ""
    @State private var weight4 = ""
    
    @StateObject private var coursesViewModel = CoursesViewModel()
    @StateObject private var cloViewModel = CLOViewModel()
    @StateObject private var gridviewheaderViewModel = GridViewHeaderViewModel()
    @StateObject private var gridviewweightageViewModel = GridViewWeightageViewModel()
    
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        VStack {
            Text("Grid")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Text("Course")
                .bold()
                .padding()
                .font(.title3)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
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
                        fetchAssignedCLO()
                        selectedCLOCode = nil
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(8)
            .padding(.horizontal)
            
            Text("CLO")
                .bold()
                .padding()
                .font(.title3)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack{
                ScrollView {
                    HStack {
                        ForEach(cloViewModel.existing, id: \.clo_id) { clo in
                            Text(clo.clo_code)
                                .foregroundColor(selectedCLOCode?.clo_code == clo.clo_code ? Color.teal : Color.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.opacity(0.8))
                                )
                                .onTapGesture {
                                    selectedCLOCode = CLO(clo_id: clo.clo_id, clo_code: clo.clo_code, clo_text: clo.clo_text, status: clo.status, enabledisable: clo.enabledisable)
                                }
                        }
                    }
                }
            }
            .frame(height: 70)
            Text("Assessments")
                .font(.title3)
                .cornerRadius(8)
                .foregroundColor(Color.yellow)
            VStack {
                VStack {
                    LazyHStack {
                        ForEach(gridviewheaderViewModel.gvh, id: \.self) { cr in
                            VStack {
                                Spacer()
                                Text(cr.name)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                Text("\(String(cr.weightage)) %")
                                    .font(.headline)
                                    .foregroundColor(Color.black)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.gray) // Set the background color to gray
                                            .frame(maxWidth: .infinity)
                                    )
                                Spacer()
                            }
                            .padding(10)
                        }
                    }
                    
                    if gridviewheaderViewModel.gvh.isEmpty {
                        Text("No Header Data Found")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                )
                .frame(height: 120)
                .onAppear {
                    coursesViewModel.fetchExistingCourses()
                    gridviewheaderViewModel.fetchExistingGrid()
                }
                Spacer()
                HStack{
                    if let selectedCLO = selectedCLOCode {
                        Text(selectedCLO.clo_code)
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundColor(Color.orange)

                    }
                    Spacer()
                    TextField("", text: $weight1)
                        .padding()
                        .frame(width: 50, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $weight2)
                        .padding()
                        .frame(width: 50, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $weight3)
                        .padding()
                        .frame(width: 50, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $weight4)
                        .padding()
                        .frame(width: 50, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    Spacer()
                }
                .padding(.horizontal)
                Rectangle()
                    .frame(height: 2)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                Spacer()
            }
            Button("Update"){
                if let selectedCLO = selectedCLOCode {
                    createGridViewWeightage(cloID: selectedCLO.clo_id)
                }
            }
            .bold()
            .padding()
            .frame(width: 100)
            .foregroundColor(.black)
            .background(Color.teal)
            .cornerRadius(8)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .trailing)
            Spacer()
            VStack{
                HStack{
                    Text(">>>")
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                    Text("Asg")
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                    Text("Quiz") // Title text
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                    Text("Mid") // Title text
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                    Text("Final") // Title text
                        .font(.title2)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity)
                }
                ScrollView {
                    ForEach(gridviewweightageViewModel.gvh, id: \.self) { cr in
                        HStack{
                            Text("\(String(cr.clo_code))")
                                .font(.headline)
                                .foregroundColor(Color.yellow)
                                .frame(maxWidth: .infinity)
                            Text("\(String(cr.weightage1))")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                            Text("\(String(cr.weightage2))")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                            Text("\(String(cr.weightage3))")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                            Text("\(String(cr.weightage4))")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                        }
                        Divider()
                            .background(Color.white)
                            .padding(1)
                    }
                    if gridviewweightageViewModel.gvh.isEmpty {
                        Text("No Grid View Weightage Found")
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
            .frame(height:200)
            .onAppear {
                gridviewweightageViewModel.fetchExistingGridWeightage()
            }
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
    func fetchAssignedCLO() {
        if let courseID = selectedCourse?.c_id {
            cloViewModel.getCourseCLO(courseID: courseID)
        }
    }
    func createGridViewWeightage(cloID: Int) {
        guard let url = URL(string: "http://localhost:2000/gridviewweightage") else {
            return
        }

        let user = [
            "clo_id": cloID,
            "weightage1": weight1,
            "weightage2": weight2,
            "weightage3": weight3,
            "weightage4": weight4
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
//                    cloViewModel.getCourseCLO(courseID: c_id) // Refresh faculties after creating a new one
//                    showAlert = true
                    DispatchQueue.main.async {
                        weight1 = ""
                        weight2 = ""
                        weight3 = ""
                        weight4 = ""
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

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
