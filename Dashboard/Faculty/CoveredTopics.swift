//////
//////  CT.swift
//////  Director Dashboard
//////
//////  Created by ADJ on 02/03/2024.
//////
////
//
//
import SwiftUI



struct CoveredTopics: View {
    
    
    var f_id: Int
    var c_id: Int
    var c_code: String
    var c_title: String
    
    var subtopics: SubTopic
    
    @State private var showCoveredTopics = false
    
    @State private var searchText = ""
    @State private var isSelected: Bool = false
    
    @State private var allTopicID: SubTopic?
    @State private var selectedTopic = Set<Int>()
    @State private var selectedSubTopic = Set<Int>()
    @State private var expandedTopics = Set<Int>()
    @State private var showTaughtCheckboxes = false
    @State private var showCommonCheckboxes = false
    
    @StateObject private var topicViewModel = TopicViewModel()
    @StateObject private var facultyViewModel = FacultiesViewModel()
    @StateObject private var subtopicViewModel = SubTopicViewModel()
    @StateObject private var topicTaughtViewModel = TopicTaughtViewModel()
    
    var filteredTopics: [Topic] {
        if searchText.isEmpty {
            return topicViewModel.existing
        } else {
            return topicViewModel.existing.filter { topic in
                let topicMatches = topic.t_name.localizedCaseInsensitiveContains(searchText)
                let subtopicMatches = subtopicViewModel.existing.contains(where: { topic.t_id == $0.t_id && $0.st_name.localizedCaseInsensitiveContains(searchText) })
                return topicMatches || subtopicMatches
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Covered Topics")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                
                Spacer()
                
                Text("\(c_title)")
                    .bold()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .leading)
                    .font(.title2)
                    .foregroundColor(Color.white)
                
                Text("\(c_code)")
                    .padding(.horizontal)
                    .font(.title3)
                    .frame(maxWidth: .infinity , alignment: .leading)
                    .foregroundColor(Color.white)
                
                VStack {
                    HStack {
                        Button(action: {
                            showTaughtCheckboxes.toggle()
                        }) {
                            Text("Covered")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        Button(action: {
                            showCommonCheckboxes.toggle()
                        }) {
                            Text("Common")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    
                    ScrollView {
                        ForEach(filteredTopics, id: \.self) { topic in
                            DisclosureGroup(
                                isExpanded: Binding(
                                    get: { expandedTopics.contains(topic.t_id) },
                                    set: { isExpanded in
                                        if isExpanded {
                                            expandedTopics.insert(topic.t_id)
                                            subtopicViewModel.getTopicSubTopic(topicID: topic.t_id)
                                        } else {
                                            expandedTopics.remove(topic.t_id)
                                        }
                                    }
                                )
                            ) {
                                ForEach(subtopicViewModel.existing.filter { $0.t_id == topic.t_id }, id: \.st_id) { subtopic in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Button(action: {
                                                toggleCourseSelection(topicID: topic.t_id, subtopicID: subtopic.st_id)
                                            }) {
                                                Image(systemName: selectedSubTopic.contains(subtopic.st_id)
                                                      || (showTaughtCheckboxes && topicTaughtViewModel.taught.contains(where: { $0.t_id == topic.t_id && $0.st_id == subtopic.st_id }))
                                                      || (showCommonCheckboxes && topicTaughtViewModel.commonTopics[topic.t_id]?.contains(subtopic.st_id) == true) ? "checkmark.square.fill" : "square")
                                                .font(.title2)
                                                .foregroundColor(showCommonCheckboxes && topicTaughtViewModel.commonTopics[topic.t_id]?.contains(subtopic.st_id) == true ? .green : (topicTaughtViewModel.taught.contains(where: { $0.t_id == topic.t_id && $0.st_id == subtopic.st_id }) ? .white : .white))
                                                .padding(.horizontal)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            .disabled(topicTaughtViewModel.taught.contains(where: { $0.t_id == topic.t_id }))
                                            
                                            Text(subtopic.st_name)
                                                .foregroundColor(Color.white)
                                                .padding(.horizontal)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        if showCommonCheckboxes && topicTaughtViewModel.commonTopics[topic.t_id]?.contains(subtopic.st_id) == true {
                                            ForEach(topicTaughtViewModel.getCommonFacultyNames(for: topic.t_id), id: \.self) { facultyName in
                                                Text("Taught by: \(facultyName)")
                                                    .foregroundColor(.orange)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                    }
                                }
                                
                                .padding(5)
                            } label: {
                                HStack {
                                    Button(action: {
                                        toggleCourseSelection(topicID: topic.t_id, subtopicID: topic.t_id)
                                    }) {
                                        Image(systemName: selectedTopic.contains(topic.t_id)  || (showTaughtCheckboxes && topicTaughtViewModel.taught.contains(where: { $0.t_id == topic.t_id && $0.t_id == topic.t_id })) || (showCommonCheckboxes && topicTaughtViewModel.commonTopics[topic.t_id] != nil) ? "checkmark.square.fill" : "square")
                                            .font(.title2)
                                            .foregroundColor(showCommonCheckboxes && topicTaughtViewModel.commonTopics[topic.t_id] != nil ? .green : (topicTaughtViewModel.taught.contains(where: { $0.t_id == topic.t_id }) ? .white : .white))
                                            .padding(.horizontal)
                                    }
                                    .disabled(topicTaughtViewModel.taught.contains(where: { $0.t_id == topic.t_id }))
                                    
                                    Text("\(topic.t_name)")
                                        .font(.headline)
                                        .foregroundColor(Color.white)
                                }
                                .padding()
                            }
                        }
                        
                        if filteredTopics.isEmpty {
                            Text("No Topic Found For Course - \(c_title)")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.green.opacity(0.5), lineWidth: 2)
                    )
                    .frame(height: 550)
                    .onAppear {
                        topicViewModel.getCourseTopic(courseID: c_id)
                        if let topicID = allTopicID {
                            subtopicViewModel.getTopicSubTopic(topicID: topicID.t_id)
                        }
                        topicTaughtViewModel.getTopicTaught(courseID: c_id, facultyID: f_id)
                        topicTaughtViewModel.getAllTopicTaught(courseID: c_id)
                    }
                }
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fiii").resizable().ignoresSafeArea())
        }
    }
//    func isCommonTopic(topicID: Int) -> Bool {
//        let taughtTopics = topicTaughtViewModel.taught.filter { $0.t_id == topicID }
//        let uniqueFacultyIDs = Set(taughtTopics.map { $0.f_id })
//        return uniqueFacultyIDs.count > 1
//    }
    private func toggleCourseSelection(topicID: Int, subtopicID: Int) {
        if selectedSubTopic.contains(subtopicID) {
            selectedSubTopic.remove(subtopicID)
        } else {
            selectedSubTopic.insert(subtopicID)
        }
        
        if !selectedTopic.contains(topicID) {
            selectedTopic.insert(topicID)
        }
        
        // Check if the topic and subtopic are already taught
        if topicTaughtViewModel.taught.contains(where: { $0.t_id == topicID && $0.st_id == subtopicID }) {
            // Remove the topic and subtopic from the selection
            selectedSubTopic.remove(subtopicID)
            selectedTopic.remove(topicID)
        }
        createCoveredTopic(facultyID: f_id, courseID: c_id, topicID: topicID, subtopicID: subtopicID)
    }
    private func createCoveredTopic(facultyID: Int, courseID: Int, topicID: Int, subtopicID: Int) {
        let url = URL(string: "http://localhost:4000/coveredtopics")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "f_id": facultyID,
            "c_id": courseID,
            "t_id": topicID,
            "st_id": subtopicID,
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
}
struct CoveredTopics_Previews: PreviewProvider {
    static var previews: some View {
        CoveredTopics(f_id:34, c_id: 1, c_code: "", c_title: "", subtopics: SubTopic(t_id: 0, st_id: 0, st_name: "", status: ""))
    }
}

