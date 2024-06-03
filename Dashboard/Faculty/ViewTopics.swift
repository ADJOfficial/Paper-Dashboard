//
//  ViewTopics.swift
//  Director Dashboard
//
//  Created by ADJ on 14/01/2024.
//

import SwiftUI

struct ViewTopics: View { // Design 100% Ok
    
    var f_id: Int
    var c_id: Int
    var c_title: String
    var t_id: Int

    @State private var selectedCLOs: [Int] = []
    
    @State private var t_name = ""
    @State private var selectedCLOText = ""
    
    @State private var searchText = ""
    @StateObject private var topicViewModel = TopicViewModel()
    @StateObject private var cloViewModel = CLOViewModel()
    
    @State private var showAlert = false
    @State private var showCloTextAlert = false
    var filteredTopics: [Topic] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return topicViewModel.existing
        } else {
            return topicViewModel.existing.filter { topic in
                topic.t_name.localizedCaseInsensitiveContains(searchText)
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
        NavigationView{
            VStack{
                Text("Add Topics")
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
                    .accentColor(.green)
                VStack{
                    Text("Topic")
                        .bold()
                        .padding(.horizontal)
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("Username" , text: $t_name)
                        .padding()
                        .background(Color.gray.opacity(1))
                        .foregroundColor(Color.black)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    Text("CLOs")
                        .bold()
                        .padding()
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .center)
                    HStack {
                        ForEach(cloViewModel.existing , id:\ .self) { cr in
                            HStack{
                                Button(action: {
                                    if selectedCLOs.contains(cr.clo_id) {
                                        selectedCLOs.removeAll { $0 == cr.clo_id }
                                    } else {
                                        selectedCLOs.append(cr.clo_id)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: selectedCLOs.contains(cr.clo_id) ? "checkmark.square" : "square")
                                            .foregroundColor(selectedCLOs.contains(cr.clo_id) ? .green : .gray)
                                        Text(cr.clo_code)
                                            .font(.headline)
                                            .foregroundColor(Color.white)
                                            .gesture(TapGesture(count: 1)
                                                .onEnded {
                                                    selectedCLOText = cr.clo_text
                                                    DispatchQueue.main.async {
                                                        showCloTextAlert = true
                                                    }
                                                }
                                            )
                                    }
                                }
                                .padding(5)
                            }
                            if cloViewModel.existing.isEmpty {
                                Text("No CLO Found For Course - \(c_title)")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .onAppear {
                        cloViewModel.getCourseCLO(courseID: c_id)
                    }
                    Button("Add"){
                        createTopic()
                        for cloID in selectedCLOs {
                            if let cloIDInt = cloID as? Int {
                                createCLO_Topic_map(cloIDs: [cloIDInt], topicID: t_id)
                            }
                        }
                    }
                    .bold()
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .trailing)
                    
                    SearchBar(text: $searchText)
                        .padding()
                }
                .font(.headline)
                .foregroundColor(Color.white)
                .alert(isPresented: $showCloTextAlert) {
                    Alert(title: Text("CLO Text"), message: Text(selectedCLOText), dismissButton: .default(Text("OK")))
                }
                VStack {
                    ScrollView{
                        ForEach(filteredTopics.indices , id:\ .self) { index in
                            let cr = filteredTopics[index]
                            HStack{
                                Text(cr.t_name)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                NavigationLink{
                                    EditTopics(f_id: f_id, c_id: c_id , c_title: c_title, topic: cr)
                                        .navigationBarBackButtonHidden(true)
                                }label: {
                                    Image(systemName: "square.and.pencil.circle")
                                        .font(.title)
                                        .foregroundColor(Color.orange)
                                        .frame(maxWidth: .infinity , alignment: .trailing)
                                }
                                Image(systemName: isTopicEnabled(index) ? "checkmark.circle.fill" : "nosign")
                                    .font(.title)
                                    .foregroundColor(isTopicEnabled(index) ? .green : .red)
                                    .onTapGesture {
                                        toggleTopicStatus(index)
                                    }
                                NavigationLink{
                                    AddSubTopics(f_id: f_id, c_id: c_id, c_title: c_title, t_id: cr.t_id , t_name: cr.t_name)
                                        .navigationBarBackButtonHidden(true)
                                }label: {
                                    Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color.orange)
                                }
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
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
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.5), lineWidth: 2)
                )
                .frame(height:300)
                .onAppear {
                    topicViewModel.getCourseTopic(courseID: c_id)
                }
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fiii").resizable().ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Congratulations"), message: Text("Topic Created Successfully"), dismissButton: .default(Text("OK")))
            }
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
    func createTopic() {
        guard let url = URL(string: "http://localhost:4000/addtopic1") else {
            return
        }
        
        let user = [
            "c_id": c_id,
            "t_name": t_name
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
                    if let result = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let topicID = result["t_id"] as? Int {
                        self.createCLO_Topic_map(cloIDs: self.selectedCLOs, topicID: topicID)
                    }
                    self.topicViewModel.getCourseTopic(courseID: self.c_id) // Refresh topics after creating a new one
                    self.showAlert = true
                    DispatchQueue.main.async {
                        self.t_name = ""
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }
    func createCLO_Topic_map(cloIDs: [Int], topicID: Int) {
        guard let url = URL(string: "http://localhost:4000/clotopicmap") else {
            return
        }
        
        let parameters: [String: Any] = [
            "clo_id": cloIDs, // Assuming cloID is a single value
            "t_id": topicID
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
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
                    DispatchQueue.main.async {
                        self.selectedCLOs = []
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }
    func isTopicEnabled(_ index: Int) -> Bool {
        return filteredTopics[index].status == "Enable"
    }
    func toggleTopicStatus(_ index: Int) {
        let topic = filteredTopics[index]
        let newStatus = topic.status == "Enable" ? "Disable" : "Enable"
        
        guard let url = URL(string: "http://localhost:4000/enabledisabletopic/\(topic.t_id)") else {
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
                print("Error updating Topic status: \(error.localizedDescription)")
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Topic status updated successfully: \(responseString)")
                    topicViewModel.getCourseTopic(courseID: c_id)
                }
            }
        }.resume()
    }
}
        
//    func createTopic() {
//        guard let url = URL(string: "http://localhost:4000/addtopic") else {
//            return
//        }
//
//        let user = [
//            "c_id": c_id,
//            "t_name": t_name
//        ] as [String : Any]
//
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: user) else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                do {
//                    let result = try JSONSerialization.jsonObject(with: data)
//                    print("Result from server:", result)
//                    topicViewModel.getCourseTopic(courseID: c_id)// Refresh faculties after creating a new one
//                    showAlert = true
//                    DispatchQueue.main.async {
//                        t_name = ""
//                    }
//                } catch {
//                    print("Error parsing JSON:", error)
//                }
//            } else if let error = error {
//                print("Error making request:", error)
//            }
//        }.resume()
//    }
struct EditTopics: View { // Design 100% Ok
    
    var f_id: Int
    var c_id: Int
    var c_title: String
    
    var topic: Topic
    
    @State private var edittopicname = ""
    
    @State private var showAlert = false
    
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        VStack{
            Text("Edit Topic")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            VStack{
                Spacer()
                Text("Course")
                    .bold()
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .leading)
                    .font(.title2)
                    .foregroundColor(Color.white)
                Text("\(c_title)")
                    .padding()
                    .frame(maxWidth: .infinity , alignment: .center)
                    .font(.title3)
                    .foregroundColor(Color.white)
                    .onAppear{
                        edittopicname = topic.t_name
                    }
                Text("Topic")
                    .bold()
                    .padding()
                    .font(.title2)
                    .frame(maxWidth: .infinity , alignment: .leading)
                    .foregroundColor(Color.white)
                TextField("Edit Topic Name" , text:$edittopicname)
                    .padding()
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8)
                    .frame(width: 400)
                    .onAppear{
                        edittopicname = topic.t_name
                    }
//                Text("CLOs")
//                    .bold()
//                    .padding()
//                    .font(.title2)
//                    .foregroundColor(Color.white)
//                    .frame(maxWidth: .infinity , alignment: .leading)
//                HStack {
//                    Spacer()
//                    Text("CLO:1")
//                    Image(systemName: "square")
//                    Text("CLO:2")
//                    Image(systemName: "checkmark.square")
//                        .foregroundColor(.green)
//                    Text("CLO:3")
//                    Image(systemName: "square")
//                    Text("CLO:4")
//                    Image(systemName: "checkmark.square")
//                        .foregroundColor(.green)
//                    Spacer()
//                }
                .padding()
                .font(.title3)
                .foregroundColor(.white)
                Spacer()
            }
            Button("Update"){
                updateTopic()
                showAlert
            }
            .bold()
            .padding()
            .frame(width: 150)
            .foregroundColor(.black)
            .background(Color.green)
            .cornerRadius(8)
            .padding(.all)
            Spacer()
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fiii").resizable().ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Congratulations"), message: Text("Topic Updated Successfully"), dismissButton: .default(Text("OK")))
        }
    }
    func updateTopic() {
        guard let url = URL(string: "http://localhost:4000/updatetopic/\(topic.t_id)") else {
            return
        }

        let updatedSubtopic = Topic(t_id: topic.t_id, t_name: edittopicname, status: topic.status)

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
                    if let message = responseJSON?["message"] as? String, message == "Topic record updated successfully" {
                        print("Topic updated successfully")
                        showAlert = true
                    } else {
                        print("Error: Topic record not updated")
                    }
                } catch {
                    print("Error while decoding response data: \(error)")
                }
        }
        task.resume()
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

struct AddSubTopics: View { // Design 100% Ok
    
    var f_id: Int
    var c_id: Int
    var c_title: String
    var t_id: Int
    var t_name: String
    
    @State private var st_name = ""
    @State private var searchText = ""
    @StateObject var subtopicViewModel = SubTopicViewModel()
    
    @State private var showAlert = false
    
    var filteredSubTopics: [SubTopic] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return subtopicViewModel.existing
        } else {
            return subtopicViewModel.existing.filter { topic in
                topic.st_name.localizedCaseInsensitiveContains(searchText)
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
        VStack{
            Text("Add Sub Topics")
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
                .padding()
                .frame(maxWidth: .infinity , alignment: .center)
                .font(.title3)
                .foregroundColor(Color.white)
            Text("Topic")
                .bold()
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            Text("\(t_name)")
                .padding()
                .frame(maxWidth: .infinity , alignment: .center)
                .font(.title3)
                .foregroundColor(Color.white)
            VStack{
                Text("Sub Topic")
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                TextField("SubTopic Name" , text: $st_name)
                    .padding()
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
                        createSubTopic()
                        showAlert
                    }
            }
            
            SearchBar(text: $searchText)
                .padding()
            
            VStack {
                ScrollView{
                    ForEach(filteredSubTopics.indices , id:\ .self) { index in
                        let cr = filteredSubTopics[index]
                        HStack{
                            Text(cr.st_name)
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            NavigationLink{
                                EditSubTopics(f_id: f_id, c_id: c_id, c_title: c_title, t_id: t_id, t_name: t_name, subtopic: cr)
                                    .navigationBarBackButtonHidden(true)
                            }label: {
                                Image(systemName: "square.and.pencil.circle")
                                    .font(.title)
                                    .foregroundColor(Color.orange)
                                    .frame(maxWidth: .infinity , alignment: .trailing)
                            }
                            Image(systemName: isSubTopicEnabled(index) ? "checkmark.circle.fill" : "nosign")
                                .font(.title)
                                .foregroundColor(isSubTopicEnabled(index) ? .green : .red)
                                .onTapGesture {
                                    toggleSubTopicStatus(index)
                                }
                        }
                        Divider()
                            .background(Color.white)
                            .padding(1)
                    }
                    if filteredSubTopics.isEmpty {
                        Text("No Sub Topic Found For Topic - \(t_name)")
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
            .frame(height:250)
            .onAppear {
                subtopicViewModel.getTopicSubTopic(topicID: t_id)
            }
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fiii").resizable().ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Congratulations"), message: Text("Topic Created Successfully"), dismissButton: .default(Text("OK")))
        }
    }
    
    func createSubTopic() {
        guard let url = URL(string: "http://localhost:4000/addSubtopic") else {
            return
        }

        let user = [
            "t_id": t_id,
            "st_name": st_name
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
                    subtopicViewModel.getTopicSubTopic(topicID: t_id) // Refresh faculties after creating a new one
                    showAlert = true
                    DispatchQueue.main.async {
                        st_name = ""
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }
    
    func isSubTopicEnabled(_ index: Int) -> Bool {
        return filteredSubTopics[index].status == "Enable"
    }
    func toggleSubTopicStatus(_ index: Int) {
        let topic = filteredSubTopics[index]
        let newStatus = topic.status == "Enable" ? "Disable" : "Enable"
        
        guard let url = URL(string: "http://localhost:4000/enabledisablesubtopic/\(topic.t_id)") else {
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
                print("Error updating Topic status: \(error.localizedDescription)")
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Topic status updated successfully: \(responseString)")
                    subtopicViewModel.getTopicSubTopic(topicID: t_id)
                }
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
struct EditSubTopics: View { // Design 100% Ok
    
    var f_id: Int
    var c_id: Int
    var c_title: String
    var t_id: Int
    var t_name: String
    
    var subtopic: SubTopic
    
    @State private var editsubtopicname = ""
    @StateObject var subtopicViewModel = SubTopicViewModel()
    
    @State private var showAlert = false
    
    var body: some View { // Get All Data From Node MongoDB : Pending
       
        NavigationView{
            VStack{
                Text("Edit Sub Topic")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                            Spacer()
                VStack{
                    Text("Course")
                        .bold()
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity , alignment: .leading)
                        .font(.title2)
                        .foregroundColor(Color.white)
                    Text("\(c_title)")
                        .padding()
                        .frame(maxWidth: .infinity , alignment: .center)
                        .font(.title3)
                        .foregroundColor(Color.white)
                    //                Spacer()
                    Text("Topic")
                        .bold()
                        .padding()
                        .font(.title2)
                        .frame(maxWidth: .infinity , alignment: .leading)
                        .foregroundColor(Color.white)
                    Text("\(t_name)")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity , alignment: .center)
                        .font(.title3)
                        .foregroundColor(Color.white)
                    Text("Sub Topic")
                        .bold()
                        .padding()
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("SubTopic Name" , text: $editsubtopicname)
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onAppear{
                            editsubtopicname = subtopic.st_name
                        }
                }
                Spacer()
                Button("Update"){
                    updateSubTopic()
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
            .navigationBarItems(leading: backButton)
            .background(Image("fiii").resizable().ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Congratulations"), message: Text("SubTopic Updated Successfully"), dismissButton: .default(Text("OK")))
            }
        }
    }
    func updateSubTopic() {
        guard let url = URL(string: "http://localhost:4000/updateanysubtopic/\(subtopic.t_id)") else {
            return
        }

        let updatedSubtopic = SubTopic(t_id: subtopic.t_id, st_id: subtopic.st_id, st_name: editsubtopicname, status: subtopic.status)

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
                    if let message = responseJSON?["message"] as? String, message == "SubTopic record updated successfully" {
                        print("Subtopic updated successfully")
                        showAlert = true
                    } else {
                        print("Error: Subtopic record not updated")
                    }
                } catch {
                    print("Error while decoding response data: \(error)")
                }
        }
        task.resume()
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

struct ViewTopics_Previews: PreviewProvider {
    static var previews: some View {
        ViewTopics(f_id: 0, c_id: 1, c_title: "", t_id: 0)
    }
}
