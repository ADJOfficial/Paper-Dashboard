////
////  CT.swift
////  Director Dashboard
////
////  Created by ADJ on 02/03/2024.
////
//
//import SwiftUI
//
//
//
//struct CoveredTopics: View {
//    
//    
//    var f_id: Int
//    var c_id: Int
//    var c_code: String
//    var c_title: String
//    var t_id: Int
//    var t_name: String
//    
//    var subtopics: SubTopic
//    
//    @State private var searchText = ""
//    @State private var isSelected: Bool = false
//    
//    @State private var selectedTopic: Set<Int> = []
//    @State private var selectedSubTopic: Set<Int> = []
//    
//    @StateObject private var topicViewModel = TopicViewModel()
//    @StateObject private var subtopicViewModel = SubTopicViewModel()
//    
//    var filteredTopics: [Topic] {
//        if searchText.isEmpty {
//            return topicViewModel.existing
//        } else {
//            return topicViewModel.existing.filter { topic in
//                let topicMatches = topic.t_name.localizedCaseInsensitiveContains(searchText)
//                let subtopicMatches = subtopicViewModel.existing.contains(where: { topic.t_id == $0.t_id && $0.st_name.localizedCaseInsensitiveContains(searchText) })
//                return topicMatches || subtopicMatches
//            }
//        }
//    }
//    
//    var body: some View { // Backend Functtionaliity Missing
//        NavigationView{
//            VStack{
//                Text("Covered Topics")
//                    .bold()
//                    .font(.largeTitle)
//                    .foregroundColor(Color.white)
//                
//                Spacer()
//                
//                Text("\(c_title)")
//                    .bold()
//                    .padding(.horizontal)
//                    .frame(maxWidth: .infinity , alignment: .leading)
//                    .font(.title2)
//                    .foregroundColor(Color.white)
//                Text("\(c_code)")
//                    .padding(.horizontal)
//                    .font(.title3)
//                    .frame(maxWidth: .infinity , alignment: .leading)
//                    .foregroundColor(Color.white)
//                
//                VStack {
//                    ScrollView{
//                        ForEach(filteredTopics , id:\ .self) { cr in
//                           DisclosureGroup {
//                               ForEach(subtopicViewModel.existing.filter { cr.t_id ==  $0.t_id }, id: \.st_id) { subtopic in
//                                   HStack{
//                                       Button(action: {
//                                           toggleCourseSelection(topicID: cr.t_id, subtopicID: subtopic.t_id)
//                                                   
//                                       }) {
//                                           Image(systemName: selectedSubTopic.contains(subtopic.t_id) ? "checkmark.square.fill" : "square")
//                                               .font(.title2)
//                                               .foregroundColor(Color.white)
//                                               .padding(.horizontal)
//                                               .frame(maxWidth: .infinity, alignment: .trailing)
//                                       }
//                                       Text(subtopic.st_name)
//                                           .foregroundColor(Color.white)
//                                           .padding(.horizontal)
//                                           .frame(maxWidth: .infinity, alignment: .leading)
//                                   }
//                               }
//                                .padding(5)
//                        }
//                        label: {
//                            HStack {
//                                Button(action: {
//                                    toggleCourseSelection(topicID: cr.t_id, subtopicID: t_id)
//
//                                }) {
//                                    Image(systemName: selectedTopic.contains(cr.t_id) ? "checkmark.square.fill" : "square")
//                                        .font(.title2)
//                                        .foregroundColor(Color.white)
//                                        .padding(.horizontal)
//                                }
//                                Text(cr.t_name)
//                                    .font(.headline)
//                                    .foregroundColor(Color.white)
//                            }
//                            .padding()
//                        }
//                    }
//                        if filteredTopics.isEmpty {
//                            Text("No Topic Found For Course - \(c_title)")
//                                .font(.headline)
//                                .foregroundColor(.orange)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                        }
//                    }
//                    .padding()
//                }
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(Color.green.opacity(0.5), lineWidth: 2)
//                )
//                .frame(height:600)
//                .onAppear {
//                    topicViewModel.getCourseTopic(courseID: c_id)
//                    subtopicViewModel.getTopicSubTopic(topicID: 1)
//                }
//            }
//            .background(Image("fiii").resizable().ignoresSafeArea())
//        }
//    }
//    private func toggleCourseSelection(topicID: Int, subtopicID: Int) {
//            if selectedTopic.contains(topicID) {
//                selectedTopic.remove(topicID)
//            } else {
//                selectedTopic.insert(topicID)
//            }
//            
//            if selectedSubTopic.contains(subtopicID) {
//                selectedSubTopic.remove(subtopicID)
//            } else {
//                selectedSubTopic.insert(subtopicID)
//            }
//            
//            createCoveredTopic(facultyID: f_id , courseID: c_id, topicID: topicID, subtopicID: subtopicID)
//        }
//        
//        private func createCoveredTopic(facultyID: Int, courseID: Int, topicID: Int, subtopicID: Int) {
//            let url = URL(string: "http://localhost:4000/coveredtopics")!
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            
//            let parameters: [String: Any] = [
//                "f_id": facultyID,
//                "c_id": courseID,
//                "t_id": topicID,
//                "st_id": subtopicID,
//            ]
//            
//            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Error: \(error)")
//                    // Handle the error as needed
//                    return
//                }
//                
//                guard let data = data else {
//                    print("No data received")
//                    // Handle the absence of data as needed
//                    return
//                }
//                
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        if let message = json["message"] as? String {
//                            print(message)
//                            // Update the UI or perform any other action based on the message
//                        }
//                    } else {
//                        print("Invalid JSON response")
//                        // Handle the invalid JSON response as needed
//                    }
//                } catch {
//                    print("Error parsing JSON response: \(error)")
//                    // Handle the JSON parsing error as needed
//                }
//            }.resume()
//        }
//    }
//
//struct CoveredTopics_Previews: PreviewProvider {
//    static var previews: some View {
//        CoveredTopics(f_id:1, c_id: 1, c_code: "", c_title: "", t_id: 6, t_name: "", subtopics: SubTopic(st_id: 0, st_name: "", status: ""))
//    }
//}
