//
//  PaperMaking.swift
//  Director Dashboard
//
//  Created by ADJ on 16/03/2024.
//

import SwiftUI

struct PaperQuestions: View {
    
    let paperID: Int
    var q_id: Int
    var p_id: Int
    var c_id: Int
    var c_code: String
    var c_title: String
    var f_id: Int
    var f_name: String
    var clo_text: String
    var t_name: String
    var exam_date: String
    var degree: String
    var duration: Int
    var t_marks: Int
    
    
    @State private var q_image: UIImage?
    
    @State private var selectedCLOText: String = ""
    @State private var selectedQuestionIndex: Int?
    @State private var isAccepted = false // For Accept All CheckMark
    @State private var paperStatus: String = ""
    @State private var showApprovedPaperButton = false
    @State private var showRejectedPaperButton = false
    @State private var showAlert = false
    
//    @State private var q_text = ""
//    @State private var q_image = ""
    @State private var fb_details = ""
    @StateObject private var questionViewModel = QuestionViewModel()
    
    @State private var selectedButton: [Int: String] = [:]
    @State private var searchText = ""
    var filteredQuestions: [GetPaperQuestions] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return questionViewModel.uploadedQuestions
        } else {
            return questionViewModel.uploadedQuestions.filter { topic in
                topic.q_text.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Paper")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                HStack{
                    Image(systemName: "mail.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.green)
                    Text("Barani Institute of Information Technology\n         PMAS Arid Agriculture University\n                     Rawalpindi Pakistan\n        Fall 2024: Mid Term Examination")
                        .foregroundColor(Color.white)
                    Image(systemName: "mail.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.green)
                }
                Spacer()
                ScrollView{
                    VStack{
                        HStack{
                            Text("Course Title: \(c_title)")
                                .padding(1)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("Course Code: \(c_code)")
                                .padding(1)
                                .frame(maxWidth: .infinity , alignment: .leading)
                        }
                        HStack{
                            Text("Date: \(exam_date)")
                                .padding(1)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("Duration: \(duration)")
                                .padding(1)
                                .frame(maxWidth: .infinity , alignment: .leading)
                        }
                        HStack{
                            Text("Degree: \(degree)")
                                .padding(1)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("Total Marks: \(t_marks)")
                                .padding(1)
                                .frame(maxWidth: .infinity , alignment: .leading)
                        }
                        Text("Teacher: \(f_name)")
                            .padding(1)
                    }
                }
                .padding()
                .foregroundColor(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                )
                .frame(height: 150)
                HStack{
                    Text("Accept All")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .trailing)
                    Button(action: {
                        isAccepted.toggle()
                        if isAccepted {
                            // Iterate through all table records and set them as "Approved"
                            for question in questionViewModel.uploadedQuestions {
                                selectedButton[question.q_id] = "Approved"
                            }
                            updateAllQuestionStatus(q_verification: "Approved")
                        } else {
                            selectedButton = [:]
                            updateAllQuestionStatus(q_verification: "")
                        }
                        updateApprovedPaperButtonVisibility()
                    }) {
                        Image(systemName: isAccepted ? "checkmark.square.fill" : "square")
                            .font(.title2)
                            .foregroundColor(Color.green)
                            .padding(.horizontal)
                    }
                }
                VStack{
                    ScrollView{
                        ForEach(filteredQuestions.indices ,  id: \.self) { index in
                            let cr = filteredQuestions[index]
                            VStack {
                                if let index = questionViewModel.uploadedQuestions.firstIndex(of: cr) {
                                    let binding = Binding<String>(
                                        get: {
                                            questionViewModel.uploadedQuestions[index].q_text
                                        },
                                        set: { newValue in
                                            questionViewModel.uploadedQuestions[index].q_text = newValue
                                        }
                                    )
                                    HStack{
                                        Text("Question # 0\(index + 1)")
                                            .font(.headline)
                                            .foregroundColor(Color.orange)
                                            .frame(maxWidth: .infinity , alignment: .leading)
                                            .gesture(
                                                DragGesture()
                                                    .onEnded { value in
                                                        if value.translation.width > 100 {
                                                            selectedQuestionIndex = index
                                                        }
                                                    }
                                            )
                                        NavigationLink{
                                            AdditionalQuestions(p_id: cr.p_id , c_title: cr.c_title , c_code: cr.c_code, selectedQuestionIndex: $selectedQuestionIndex)
                                                .navigationBarBackButtonHidden(true)
                                        }label: {
                                            Image(systemName: "fibrechannel")
                                        }
                                        .font(.title3)
                                        .foregroundColor(Color.mint)
                                    }
                                    Text("\(cr.q_text)")
                                        .font(.title3)
                                        .padding(2)
                                        .padding(.horizontal)
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                }
                                HStack {
                                    if let base64Image = cr.q_image,
                                       let imageData = Data(base64Encoded: base64Image),
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    Text("[ \(cr.t_name) , \(cr.q_difficulty) , \(cr.q_marks) , \(cr.clo_code) ]")
                                        .font(.title3)
                                        .padding(.horizontal)
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                HStack {
                                    
                                    Button(action: {
                                        selectedButton[cr.q_id] = "Approved"
                                        updateQuestionStatus(questionId: cr.q_id, q_verification: "Approved")
                                        updateApprovedPaperButtonVisibility()
                                    }) {
                                        Image(systemName: selectedButton[cr.q_id] == "Approved" ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(selectedButton[cr.q_id] == "Approved" ? .green : .gray)
                                        Text("Approved")
                                            .font(.title3)
                                            .foregroundColor(selectedButton[cr.q_id] == "Approved" ? .green : .gray)
                                    }
                                    .onTapGesture {
                                        if selectedButton[cr.q_id] == "Approved" {
                                            selectedButton[cr.q_id] = nil
                                        } else {
                                            selectedButton[cr.q_id] = "Approved"
                                        }
                                        updateApprovedPaperButtonVisibility()
                                    }
                                    
                                    Button(action: {
                                        selectedButton[cr.q_id] = "Rejected"
                                        updateQuestionStatus(questionId: cr.q_id, q_verification: "Rejected")
                                        updateApprovedPaperButtonVisibility()
                                    }) {
                                        Image(systemName: selectedButton[cr.q_id] == "Rejected" ? "largecircle.fill.circle" : "circle")
                                            .foregroundColor(selectedButton[cr.q_id] == "Rejected" ? .red : .gray)
                                        Text("Rejected")
                                            .font(.title3)
                                            .foregroundColor(selectedButton[cr.q_id] == "Rejected" ? .red : .gray)
                                    }
                                    .onTapGesture {
                                        if selectedButton[cr.q_id] == "Rejected" {
                                            selectedButton[cr.q_id] = nil
                                        } else {
                                            selectedButton[cr.q_id] = "Rejected"
                                        }
                                        updateApprovedPaperButtonVisibility()
                                    }
                                }
                                
                                .padding()
                                .frame(maxWidth: .infinity , alignment: .trailing)
                                HStack{
                                    TextField("Type Comment" , text: $fb_details)
                                        .padding()
                                        .font(.headline)
                                        .background(Color.gray.opacity(0.8))
                                        .cornerRadius(8)
                                        .padding(.horizontal)
                                    Button(action: {
                                        createFeedback()
                                    }, label: {
                                        Image(systemName: "paperplane.fill")
                                            .font(.title)
                                            .padding(.horizontal)
                                            .foregroundColor(Color.green)
                                    })
                                }
                            }
                            Divider()
                                .background(Color.white)
                                .padding()
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                )
                .frame(height: 400)
                .onAppear {
                    questionViewModel.getPaperQuestions(paperID: p_id)
                }
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink {
                        PaperTopic(c_id: c_id, t_name: t_name, c_title: c_title, c_code: c_code, questionTopics: questionViewModel.uploadedQuestions.map { $0.t_name }, cloCodes: questionViewModel.uploadedQuestions.map { ($0.clo_text , $0.clo_code) })
                            .navigationBarBackButtonHidden(true)
                    }label: {
                        Text("View Topics")
                    }
                    .bold()
                    .padding()
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .background(Color.brown.opacity(0.7))
                    .cornerRadius(8)
                    Spacer()
                    Button(action: {
                        if showRejectedPaperButton {
                            updatePaperStatusToRejected(paperID: p_id)
                            paperStatus = "Rejected"
                        } else {
                            updateApprovedPaperButtonVisibility()
                            updatePaperStatusToApproved(paperID: p_id)
                            paperStatus = "Approved"
                        }
                    }) {
                        Text(showApprovedPaperButton ? "Approved" : "Reject")
                            .bold()
                            .padding()
                            .frame(width: 150)
                            .foregroundColor(.black)
                            .background(showApprovedPaperButton ? Color.brown.opacity(0.7) : Color.red.opacity(0.7))
                            .cornerRadius(8)
                    }
                    .opacity(showApprovedPaperButton || showRejectedPaperButton ? 1 : 0)
                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Paper Status Updated"), message: Text("Paper status has been set to \(paperStatus)."), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarItems(leading: backButton)
            .background(Image("ft").resizable().ignoresSafeArea())
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
    
    func updateAllQuestionStatus(q_verification: String) {
        for index in 0..<questionViewModel.uploadedQuestions.count {
            let questionId = questionViewModel.uploadedQuestions[index].q_id
            updateQuestionStatus(questionId: questionId, q_verification: q_verification)
        }
    }
    
    private func updateQuestionStatus(questionId: Int, q_verification: String) {
        var qVerificationValue: String
           if q_verification.isEmpty {
               qVerificationValue = "Pending"
           } else {
               qVerificationValue = q_verification
           }
        
        let url = URL(string: "http://localhost:3000/updatequestionstatus/\(questionId)")!
        let parameters = ["q_verification": qVerificationValue]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating question status: \(error.localizedDescription)")
            } else if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Question status updated successfully: \(responseString)")
                    // Handle the response as needed
                }
            }
        }.resume()
    }
    func createFeedback() {
        guard let url = URL(string: "http://localhost:3000/addfeedback") else {
            return
        }

        let user = [
            "f_id": f_id,
            "c_id": c_id,
            "p_id": p_id,
            "q_id": q_id,
            "fb_details": fb_details
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
//                    facultiesViewModel.fetchExistingFaculties() // Refresh faculties after creating a new one
                    DispatchQueue.main.async {
                        fb_details = ""
                        
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }

//    private func updateApprovedPaperButtonVisibility() {
//        let allApproved = questionViewModel.uploadedQuestions.allSatisfy { assignedQuestion in
//            selectedButton[assignedQuestion.q_id] == "Approved"
//        }
//
//        showApprovedPaperButton = allApproved
//    }
    private func updateApprovedPaperButtonVisibility() {
        let allApproved = questionViewModel.uploadedQuestions.allSatisfy { assignedQuestion in
            selectedButton[assignedQuestion.q_id] == "Approved"
        }
        
        let allRejected = questionViewModel.uploadedQuestions.allSatisfy { assignedQuestion in
            selectedButton[assignedQuestion.q_id] == "Rejected"
        }

        showApprovedPaperButton = allApproved && !allRejected
        showRejectedPaperButton = allRejected && !allApproved
    }
    
    func updatePaperStatusToApproved(paperID: Int) {
            guard let url = URL(string: "http://localhost:3000/updatepaperstatustoapproved/\(paperID)") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    print("Error updating paper status")
                    return
                }

                if response.statusCode == 200 {
                    print("Paper status updated to Approved")
                    self.showAlert = true
                } else {
                    print("Paper status was not updated")
                }
            }.resume()
        }
    func updatePaperStatusToRejected(paperID: Int) {
        guard let url = URL(string: "http://localhost:3000/updatepaperstatustorejected/\(paperID)") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    print("Error updating paper status")
                    return
                }

                if response.statusCode == 200 {
                    print("Paper status updated to Approved")
                    self.showAlert = true
                } else {
                    print("Paper status was not updated")
                }
            }.resume()
        }
}

struct AcceptRejectRadioButton: View { // For Radio Button
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(title)
            }
        }
    }
}

struct PaperTopic: View { // For Radio Button
    
    var c_id: Int
    var t_name : String
    var c_title: String
    var c_code: String
    var questionTopics: [String]
    let cloCodes: [(String , String)]
    
    @State private var searchText = ""
    var filteredTopics: [String] {
            if searchText.isEmpty {
                return questionTopics
            } else {
                return questionTopics.filter { topic in
                    topic.localizedCaseInsensitiveContains(searchText)
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
    
    var body: some View {
        
        VStack {
            Text("Paper Topic")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            
            Text(c_title)
                .bold()
                .font(.title2)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            Text(c_code)
                .font(.title3)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
//
//            SearchBar(text: $searchText)
//                .padding()
            Text("Questions Topics")
                .bold()
                .font(.title2)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            VStack {
                ScrollView{
                    ForEach(filteredTopics.indices , id:\ .self) { index in
                        let cr = filteredTopics[index]
                        HStack{
                            Text(cr)
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("Question # 0\(index + 1)")
                                .font(.headline)
                                .foregroundColor(Color.orange)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Divider()
                            .background(Color.white)
                        .padding(1)
                    }
                    if filteredTopics.isEmpty {
                        Text("No Topic Found For This Course Paper - \(c_title)")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
            )
            .frame(height:300)
            
            Text("Questions CLOs")
                .bold()
                .font(.title2)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            VStack {
                ScrollView{
                    ForEach(cloCodes.indices , id:\ .self) { index in
                        let cr = cloCodes[index]
                        HStack{
                            Text(cr.0)
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(cr.1)
                                .bold()
                                .font(.headline)
                                .foregroundColor(Color.orange)
                        }
                        Divider()
                            .background(Color.white)
                        .padding(1)
                    }
                    if cloCodes.isEmpty {
                        Text("No CLO Found For This Course Paper - \(c_title)")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
            )
            .frame(height:300)
            
            Spacer()
        }
        .navigationBarItems(leading: backButton)
        .background(Image("ft").resizable().ignoresSafeArea())
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

struct AdditionalQuestions: View { // For Radio Button
    
    var p_id: Int
    var c_title: String
    var c_code: String
    
    @Binding var selectedQuestionIndex: Int?
    
    @StateObject private var questionViewModel = QuestionViewModel()
    
    @State private var searchText = ""
    var filteredAdditionalQuestions: [GetPaperQuestions] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return questionViewModel.uploadedQuestions
        } else {
            return questionViewModel.uploadedQuestions.filter { topic in
                topic.q_text.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        
        VStack {
            Text("Additional Questions")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            VStack {
                ScrollView{
                    ForEach(filteredAdditionalQuestions.indices , id:\ .self) { index in
                        let cr = filteredAdditionalQuestions[index]
                        Button(action: {
                            selectedQuestionIndex = index
                        }) {
                            VStack{
                                Text("Question # 0\(index + 1)")
                                    .font(.headline)
                                    .padding(2)
                                    .foregroundColor(Color.orange)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                Text(cr.q_text)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                HStack{
                                    Text("[ \(cr.t_name) , \(cr.q_difficulty) , \(cr.q_marks) , \(cr.clo_code) ]")
                                        .font(.title3)
                                        .padding(.horizontal)
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding(2)
                            }
                        }
                        .onDisappear {
                            if let selectedQuestionIndex = selectedQuestionIndex {
                                questionViewModel.sendSelectedQuestionBack(selectedQuestionIndex: selectedQuestionIndex)
                            }
                        }
                        Divider()
                            .background(Color.white)
                        .padding(1)
                    }
                    if filteredAdditionalQuestions.isEmpty {
                        Text("No Additional Questions Found For This Course Paper - \(c_title)")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .onAppear{
                questionViewModel.getPaperAdditionalQuestions(paperID: p_id)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
            )
            .frame(height:700)
            
            Spacer()
        }
        .navigationBarItems(leading: backButton)
        .background(Image("ft").resizable().ignoresSafeArea())
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

struct PaperTopic_Previews: PreviewProvider {
    static var previews: some View {
        PaperQuestions(paperID: 1, q_id: 1, p_id: 1, c_id: 1, c_code: "", c_title: "", f_id: 1, f_name: "", clo_text: "", t_name: "", exam_date: "", degree: "", duration: 1, t_marks: 1)
//        AdditionalQuestions()
//        PaperTopic(c_id: 3, t_name: "", c_title: "", c_code: "")
    }
}
