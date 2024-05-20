//
//  TopicsCovered.swift
//  Dashboard
//
//  Created by ADJ on 14/05/2024.
//

import SwiftUI

struct TopicsCovered: View {
    
    var f_id: Int
    var c_id: Int
    var c_code: String
    var c_title: String
    @State private var selectedTopic: Set<Int> = []
    @State private var searchText = ""
    @StateObject private var topicViewModel = TopicViewModel()
    @StateObject private var subtopicViewModel = SubTopicViewModel()
    
    var filteredCoveredTopics: [Topic] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return topicViewModel.existing
        } else {
            return topicViewModel.existing.filter { topic in
                topic.t_name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    var filteredSubTopic: [SubTopic] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return subtopicViewModel.existing
        } else {
            return subtopicViewModel.existing.filter { topic in
                topic.st_name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    var body: some View {
        NavigationView{
            VStack{
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
                
                Spacer()
                Text("Topics -")
                    .padding(.horizontal)
                    .bold()
                    .font(.title3)
                    .frame(maxWidth: .infinity , alignment: .leading)
                    .foregroundColor(Color.white)
                VStack {
                    ScrollView{
                        ForEach(filteredCoveredTopics.indices , id:\ .self) { index in
                            let cr = filteredCoveredTopics[index]
                            HStack{
                                Text(cr.t_name)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                        if filteredCoveredTopics.isEmpty {
                            Text("No Covered Topics Found For Course - \(c_title)")
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
                .frame(height:550)
                .onAppear {
                    topicViewModel.getCourseTopic(courseID: 1)
                }
            }
            .background(Image("fiii").resizable().ignoresSafeArea())
        }
    }
}

struct TopicsCovered_Previews: PreviewProvider {
    static var previews: some View {
        TopicsCovered(f_id: 0, c_id: 0, c_code: "", c_title: "")
    }
}
