////
////  FindPaperHistory.swift
////  Dashboard
////
////  Created by ADJ on 23/06/2024.
////
//
//import SwiftUI
//
//struct FindPaperHistory: View {
//    
//    @State private var selectedfaculty: Int?
//    
//    var body: some View {
//        VStack {
//            Picker(selection: $selectedfaculty, label: Text("")) {
//                Text("Faculties").tag(nil as Int?)
////                ForEach(facultiesViewModel.remaining, id: \.f_id) { faculty in
//                    Text(faculty.f_name)
//                        .tag(faculty.f_id as Int?)
//                }
//            }
//            .accentColor(Color.green)
//            .onChange(of: selectedfaculty) { selectedFacultyID in
//                if let selectedfacultyID = selectedFacultyID {
//                    selectedfaculty = selectedfacultyID
////                    assignedcoursesViewModel.fetchAssignedCourses(facultyID: selectedfacultyID)
//                    print("Selected Faculty ID: \(selectedfacultyID)")
//                } else {
//                    selectedfaculty = nil
//                    print("No faculty selected")
//                }
//            }
//        }
//    }
//}
//
//struct FindPaperHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        FindPaperHistory()
//    }
//}
