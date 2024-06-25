//
//  SetPaper.swift
//  Director Dashboard
//
//  Created by ADJ on 14/01/2024.
//

import SwiftUI
import PhotosUI
import MobileCoreServices

struct PaperTextFields {
    var paperName: String
    var examDate: String
    var duration: Int
    var degree: String
    var totalMarks: Int
    
}

struct SetPaper: View {
    
    var f_id: Int
    var f_name: String
    var c_id: Int
    var c_title: String
    var c_code: String
    
    var p_id: Int
    
    @State private var isChecked = false
    @State private var semIsChecked = false
    @State private var paperSetting = PaperTextFields(paperName: "", examDate: "", duration: 0, degree: "", totalMarks: 0)
    @State private var totalQuestions = ""
    @State private var selectedSemRadioButton: String? = nil
    @State private var selectedTermRadioButton: String? = nil
    @State private var selectedValue = 0
    @State private var paperStatus: String = ""
    
    @State private var showAlert = false
    
    @StateObject private var activeSessionViewModel = ActiveSessionViewModel()
    @StateObject private var coViewModel = CoViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Paper Setting")
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
               
                HStack {
                    Text("Status - \(paperStatus)")
                        .font(.title3)
                        .frame(maxWidth: .infinity , alignment: .trailing)
                        .foregroundColor(Color.white)
                    Image(systemName: isChecked ? "circle.fill" : "circle")
                        .foregroundColor(isChecked ? .green : .white)
                        .onTapGesture {
                            isChecked.toggle()
                        }
                }
                
                Text("Set Paper")
                    .bold()
                    .padding()
                    .font(.title2)
                    .frame(maxWidth: .infinity , alignment: .center)
                    .foregroundColor(Color.white)
                
                ScrollView{
                    VStack {
                        HStack{
                            Text("Teacher :")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            ScrollView{
                                ForEach(coViewModel.Courseassignedto, id: \.self) { cr in
                                    HStack{
                                        Text(cr.f_name)
                                            .font(.headline)
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: .infinity , alignment: .leading)
                                    }
                                }
                            }
                        }
                        .padding(2)
                        .onAppear {
                            coViewModel.fetchCoursesAssignedTo(courseID: c_id)
                        }
                        
                        HStack{
                            Text("Course Title :")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            Text("\(c_title)")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .center)
                                .font(.headline)
                                .foregroundColor(Color.white)
                        }
                        .padding(2)
                        
                        HStack{
                            Text("Course Code :")
                                .bold()
                                .padding(.all,1)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            Text("\(c_code)")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .center)
                                .font(.headline)
                                .foregroundColor(Color.white)
                        }
                        .padding(2)
                        
                        HStack {
                            Text("Duration :")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            TextField("" , value: $paperSetting.duration, formatter: NumberFormatter())
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(8)
                                .frame(width: 180 , height: 20)
                                .padding(.horizontal)
                        }
                        .padding(2)
                        
                        HStack {
                            Text("Degree :")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            TextField("" , text: $paperSetting.degree)
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(8)
                                .frame(width: 180 , height: 20)
                                .padding(.horizontal)
                        }
                        .padding(2)
                        
                        HStack {
                            Text("Date of Exam :")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            TextField("" , text: $paperSetting.examDate)
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(8)
                                .frame(width: 180 , height: 20)
                                .padding(.horizontal)
                        }
                        .padding(2)
                        
                        HStack {
                            Text("Question :")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            TextField("" , text: $paperSetting.examDate)
                                .background(Color.gray.opacity(0.8))
                                .cornerRadius(8)
                                .frame(width: 180 , height: 20)
                                .padding(.horizontal)
                        }
                        .padding(2)

                        VStack{
                            Text("Term :")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            HStack{
                                Spacer()
                                SemesterRadioButton(title: "Mid", isSelected: selectedTermRadioButton == "Mid") {
                                    selectedTermRadioButton = "Mid"
                                }
                                .foregroundColor(selectedTermRadioButton == "Mid" ? .green : .white)
                                Spacer()
                                SemesterRadioButton(title: "Final", isSelected: selectedTermRadioButton == "Final") {
                                    selectedTermRadioButton = "Final"
                                }
                                .foregroundColor(selectedTermRadioButton == "Final" ? .green : .white)
                                Spacer()
                            }
                        }
                        .padding(2)
                    
                        HStack{
                            Text("Session : ")
                                .font(.title2)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
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
                        .padding(1)
                    }
                    .padding()
                }
                .frame(height: 450)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.5), lineWidth: 1)
                )
                
                Spacer()
                
                HStack{
                    Spacer()
                    Button("Create"){
                        createPaper()
                    }
                    .bold()
                    .padding()
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.all)

                    Spacer()
                    
                    NavigationLink{
                        StartMakingPaper(f_id: f_id, f_name: f_name, c_id: c_id, c_title: c_title, c_code: c_code)
                            .navigationBarBackButtonHidden(true)
                    }label: {
                        Image(systemName: "arrow.right.square.fill")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color.green)
                    }
                    Spacer()
                }
                
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fiii").resizable().ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Paper Header Created"), message: Text("Click on Arrow Button To Start Making Paper Questions"), dismissButton: .default(Text("OK")))
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
    func createPaper() {
        
        guard let url = URL(string: "http://localhost:4000/createpaper") else {
            return
        }
        
        let user = [
            "p_name": paperSetting.paperName,
            "duration": paperSetting.duration,
            "degree": paperSetting.degree,
            "t_marks": paperSetting.totalMarks,
            "term": selectedTermRadioButton ?? "",
            "exam_date": paperSetting.examDate,
            "semester": selectedSemRadioButton ?? "" ,
            "t_questions": totalQuestions,
            "f_id": f_id,
            "c_id": c_id
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
                    showAlert = true
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }
}

struct SemesterRadioButton: View {
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


struct StartMakingPaper: View {
    
    
    var f_id: Int
    var f_name: String
    var c_id: Int
    var c_title: String
    var c_code: String
    @State private var paperID: Int?
    @State private var tquestion: Int?
    
    @State private var easy: Int?
    @State private var medium: Int?
    @State private var hard: Int?
    @State private var easyCount = 0
    @State private var mediumCount = 0
    @State private var hardCount = 0
    
    @State private var isAccepted = false // For Accept All CheckMark
    @State private var selectedButton: [Int: String] = [:]
    
    @State private var showAlert = false
    @State private var showAlert1 = false
    @State private var showAlertWarning = false
    @State private var alertMessage = ""
    @State private var showPopover = false
    
    @State private var q_marks = ""
    @State private var selectedDifficulty = 0
    var options = ["Easy" , "Hard" , "Medium"]
   

//    @State private var selectedClo: Int?
    @State private var selectedTopics = Set<Int>()
    
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    
    
    @State private var questions = ""
    
    @StateObject private var questionViewModel = QuestionViewModel()
    
    @StateObject private var  topicViewModel = TopicViewModel()
    @StateObject private var  cloViewModel = CLOViewModel()
    @StateObject private var  topiccloViewModel = TopicCLOViewModel()
    @StateObject private var  paperheaderViewModel = PaperHeaderViewModel()
    @StateObject private var  difficultyViewModel = DifficultyViewModel()
    @StateObject private var seniorViewModel = CourseSeniorViewModel()
    @State private var isSenior: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Paper")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                //            Spacer()
                HStack {
                    Image("u")
                        .resizable()
                        .font(.largeTitle)
                        .foregroundColor(Color.green)
                    Text("Barani Institute of Information Technology\nPMAS Arid Agriculture University\nRawalpindi Pakistan\nFall 2024: Mid Term Examination")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 260 , height: 110)
                    Image("u")
                        .resizable()
                        .foregroundColor(Color.green)
                    
                }
                VStack{
                    ScrollView {
                        ForEach(paperheaderViewModel.header.indices, id: \.self) { index in
                            let cr = paperheaderViewModel.header[index]
                            VStack{
                                Text("\(cr.p_id)")
                                    .bold()
                                    .padding(.all,1)
                                    .frame(maxWidth: .infinity , alignment: .center)
                                    .onAppear {
                                        self.paperID = cr.p_id // Store the fetched p_id
                                    }
                                Text("\(cr.t_questions)")
                                    .bold()
                                    .padding(.all,1)
                                    .frame(maxWidth: .infinity , alignment: .center)
                                    .onAppear {
                                        self.tquestion = cr.t_questions // Store the fetched p_id
                                    }
                                ForEach(difficultyViewModel.questionD.indices, id: \.self) { diffIndex in
                                    let cr = difficultyViewModel.questionD[diffIndex]
                                    Text("Easy : \(cr.easy)")
                                        .bold()
                                        .padding(.all,1)
                                        .frame(maxWidth: .infinity , alignment: .center)
                                        .onAppear {
                                            self.easy = cr.easy
                                        }
                                    Text("Medium : \(cr.medium)")
                                        .bold()
                                        .padding(.all,1)
                                        .frame(maxWidth: .infinity , alignment: .center)
                                        .onAppear {
                                            self.medium = cr.medium
                                        }
                                    Text("Hard : \(cr.hard)")
                                        .bold()
                                        .padding(.all,1)
                                        .frame(maxWidth: .infinity , alignment: .center)
                                        .onAppear {
                                            self.hard = cr.hard
                                        }
                                }
                            }
                        }
                        if paperheaderViewModel.header.isEmpty {
                            Text("No Header Found For Course - \(c_title)")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()
                .frame(height: 150)
                .foregroundColor(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.5), lineWidth: 2)
                )
                .onAppear{
                    paperheaderViewModel.fetchExistingHeader(course: c_id)
                }
                .onChange(of: tquestion) { newValue in
                    if let newPaperID = newValue {
                        difficultyViewModel.fetchExistingDifficulty(question: newPaperID)
                    }
                }
                VStack{
                    HStack{
                        Text("Question")
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity , alignment: .leading)
                    }
                    TextField("Type Question", text: $questions)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    
                    HStack{
                        Text("Difficulty :")
                            .padding(.horizontal)
                            .foregroundColor(Color.white)
                        Picker("" , selection: $selectedDifficulty) {
                            ForEach(0..<options.count) {index in
                                Text(options[index])
                            }
                        }
                        .accentColor(Color.green)
                        Spacer()
                        Text("Topic :")
                            .padding(.horizontal)
                            .foregroundColor(Color.white)
                        Menu {
                            ForEach(topicViewModel.existing, id: \.t_id) { topic in
                                Button(action: {
                                    if selectedTopics.contains(topic.t_id) {
                                        selectedTopics.remove(topic.t_id)
                                    } else {
                                        selectedTopics.insert(topic.t_id)
                                    }
                                    topiccloViewModel.getTopicCLO(topicID: topic.t_id)
                                }) {
                                    HStack {
                                        Text(topic.t_name)
                                        Spacer()
                                        if selectedTopics.contains(topic.t_id) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Text("Select")
                                .foregroundColor(.green)
                                .padding()
                                .cornerRadius(8)
                        }
                    }
                    HStack {
                        Spacer()
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .cornerRadius(30)
                                .frame(width: 100, height: 100)
                        } else {
                            Image(systemName: "photo.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color.green)
                                .onTapGesture {
                                    presentImagePicker()
                                }
                        }
                        Spacer()
                        Text("Marks :")
                            .font(.title3)
                            .foregroundColor(Color.white)
                        TextField("Marks", text: $q_marks)
                            .padding()
                            .foregroundColor(Color.black)
                            .background(Color.gray.opacity(1))
                            .cornerRadius(8)
                            .frame(width: 80)
                            .padding(.horizontal)
                        Spacer()
                        Button("Create"){
                            if let paperID = paperID{
                                createQuestion(paperID: paperID)
                            }
                        }
                        .bold()
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.green)
                        .cornerRadius(8)
                        .frame(width: 100)
                        .frame(alignment: .trailing)
                        Spacer()
                    }
                    Spacer()
                    VStack{
                        ScrollView {
                            ForEach(questionViewModel.uploadedQuestions.indices, id: \.self) { index in
                                let cr = questionViewModel.uploadedQuestions[index]
                                VStack {
                                    NavigationLink{
                                        //                                        /*p_id: p_id*/   EditPaperQuestion(f_id:f_id  , c_id: c_id , c_title: c_title , c_code: c_code , questions: cr)
                                        //                                            .navigationBarBackButtonHidden(true)
                                    }label: {
                                        Image(systemName: "square.and.pencil.circle")
                                            .font(.title)
                                            .foregroundColor(Color.orange)
                                            .frame(maxWidth: .infinity , alignment: .trailing)
                                    }
                                    VStack {
                                        Text("Question # 0\(index + 1)")
                                            .font(.headline)
                                            .foregroundColor(Color.orange)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(cr.q_text)
                                            .font(.headline)
                                            .foregroundColor(Color.white)
                                            .frame(maxWidth: .infinity , alignment: .leading)
                                        HStack {
                                            if let imageDataString = cr.imageData, let imageData = Data(base64Encoded: imageDataString), let uiImage = UIImage(data: imageData) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .cornerRadius(30)
                                                    .frame(width: 100, height: 100) // Adjust size as needed
                                            } else {
                                                Text("Image not available")
                                            }
                                            
                                            Text("[ \(cr.q_difficulty) , \(cr.q_marks) , \(cr.t_name) , \(cr.clo_code) ]")
                                                .foregroundColor(Color.yellow)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                .onAppear {
                                                    // Update difficulty counts
                                                    switch cr.q_difficulty {
                                                    case "Easy":
                                                        easyCount += 1
                                                    case "Medium":
                                                        mediumCount += 1
                                                    case "Hard":
                                                        hardCount += 1
                                                    default:
                                                        break
                                                    }
                                                }
                                                .onTapGesture {
                                                    // Toggle showPopover to true
                                                    showPopover.toggle()
                                                }
                                                .overlay(
                                                    Group {
                                                        if showPopover {
                                                            VStack {
                                                                Text("\(cr.clo_code) : \(cr.clo_text)")
                                                                    .padding()
                                                                    .foregroundColor(Color.black)
                                                                    .background(Color.gray.opacity(1))
                                                                    .cornerRadius(10)
                                                            }
                                                            .onTapGesture {
                                                                // Toggle showPopover to false when tapped outside the popover
                                                                showPopover.toggle()
                                                            }
                                                        }
                                                    }
                                                )
                                        }
                                    }
                                    Divider()
                                        .background(Color.white)
                                        .padding(1)
                                }
                            }
                            if questionViewModel.uploadedQuestions.isEmpty {
                                Text("No Questions Found For Course - \(c_title)")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            VStack {
                                if isSenior {
                                    Button(action: {
                                        if validateQuestionDistribution() {
                                            isAccepted.toggle()
                                            if isAccepted {
                                                // Iterate through all table records and set them as "Uploaded"
                                                for question in questionViewModel.uploadedQuestions {
                                                    selectedButton[question.q_id] = "Uploaded"
                                                }
                                                updateAllQuestionStatus(q_verification: "Uploaded")
                                            } else {
                                                selectedButton = [:]
                                                updateAllQuestionStatus(q_verification: "")
                                            }
                                        } else {
                                            showAlertWarning = true
                                        }
                                    }) {
                                        Text("Upload")
                                            .bold()
                                            .padding()
                                            .foregroundColor(.black)
                                            .background(Color.green)
                                            .cornerRadius(8)
                                            .frame(width: 100)
                                            .frame(alignment: .trailing)
                                    }
                                }
                            }
                        }
                        .onAppear {
                            seniorViewModel.fetchExistingSenior(course: c_id)
                        }
                        .onChange(of: seniorViewModel.senior) { newValue in
                            isSenior = newValue.contains { $0.f_id == f_id }
                        }
                        .padding()
                    }
                    //                    .padding()
                    .frame(height: 300)
                    .foregroundColor(Color.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.green.opacity(0.5), lineWidth: 2)
                    )
                    .onAppear {
                        paperheaderViewModel.fetchExistingHeader(course: c_id)
                    }
                    .onChange(of: paperID) { newValue in
                        if let newPaperID = newValue {
                            questionViewModel.getPaperQuestions(paperID: newPaperID) // Fetch questions once paperID is set
                        }
                    }
                }
                .onAppear{
                    topicViewModel.getCourseTopic(courseID: c_id)
                }
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fiii").resizable().ignoresSafeArea())
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePickerView(result: handleImagePickerResult)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Question Created Successfully"), message: Text("Click on Plus Button Below To Add More Question For This Paper if You Want..."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showAlert1) {
                Alert(title: Text("Uploaded"), message: Text("Question Uploaded Successfully Wait For Director to Approve Question"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showAlertWarning) {
                Alert(title: Text("Warning"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
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
    
    func validateQuestionDistribution() -> Bool {
        guard let tquestion = tquestion else {
            alertMessage = "Total question count not loaded correctly."
            return false
        }
        guard let easy = easy, let medium = medium, let hard = hard else {
            alertMessage = "Difficulty question counts not loaded correctly."
            return false
        }
        
        let totalDifficultyQuestions = easy + medium + hard
        
        if tquestion != totalDifficultyQuestions {
            alertMessage = "Total number of questions does not match the required total."
            return false
        }
        
        // Validate the number of easy, medium, and hard questions
        if easy != easyCount {
            alertMessage = "Number of easy questions is not complete."
            return false
        }
        if medium != mediumCount {
            alertMessage = "Number of medium questions is not complete."
            return false
        }
        if hard != hardCount {
            alertMessage = "Number of hard questions is not complete."
            return false
        }
        
        return true
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

        let url = URL(string: "http://localhost:4000/updateqverification/\(questionId)")!
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
                    showAlert1 = true
                }
            }
        }.resume()
    }
    
    func createQuestion(paperID: Int) {
        guard let url = URL(string: "http://localhost:4000/createquestion") else {
            return
        }

        guard !selectedTopics.isEmpty else {
            print("No topic selected")
            return
        }

        guard let selectTopic = topicViewModel.existing.first(where: { selectedTopics.contains(Int($0.t_id)) }) else {
            print("No topic selected")
            return
        }

        guard let selectClo = topiccloViewModel.topicCLO.first else {
            print("CLO not found for selected topic")
            return
        }

        let concatenatedTopicIDs = selectedTopics.map { String($0) }.joined(separator: ",") // Convert to comma-separated string

        var question = [
            "q_text": questions,
            "q_marks": q_marks,
            "q_difficulty": options[selectedDifficulty],
            "t_id": concatenatedTopicIDs,  // Use the concatenated string of topic IDs
            "p_id": paperID,
            "f_id": f_id,
            "c_id": c_id,
            "clo_id": selectClo.clo_id
        ] as [String: Any]


        
        let boundary = UUID().uuidString
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "--\(boundary)--\r\n"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var bodyData = Data()

        // Add question fields to the request body
        for (key, value) in question {
            bodyData.appendString(boundaryPrefix)
            bodyData.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            bodyData.appendString("\(value)\r\n")
        }

        // Add image file to the request body
        if let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            bodyData.appendString(boundaryPrefix)
            bodyData.appendString("Content-Disposition: form-data; name=\"q_image\"; filename=\"image.jpg\"\r\n")
            bodyData.appendString("Content-Type: image/jpeg\r\n\r\n")
            bodyData.append(imageData)
            bodyData.appendString("\r\n")
        }

        bodyData.appendString(boundarySuffix)

        request.httpBody = bodyData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data)
                    print("Result from server:", result)
                    questionViewModel.getPaperQuestions(paperID: paperID)
                    showAlert = true
                    DispatchQueue.main.async {
                        questions = ""
                        selectedDifficulty = 0
                        q_marks = ""
                        selectedImage = nil
                        // selectedClo = nil
                        selectedTopics = Set<Int>()
                    }

                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }

    func handleImagePickerResult(result: Result<UIImage, Error>) {
        switch result {
        case .success(let image):
            selectedImage = image
        case .failure(let error):
            print("Error selecting image: \(error.localizedDescription)")
        }
        isShowingImagePicker = false
    }
    
    func presentImagePicker() {
        isShowingImagePicker = true
    }
}
extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


struct ImagePickerView: UIViewControllerRepresentable {
    var result: (Result<UIImage, Error>) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = [kUTTypeImage as String]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No-op
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(result: result)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var result: (Result<UIImage, Error>) -> Void
        
        init(result: @escaping (Result<UIImage, Error>) -> Void) {
            self.result = result
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                result(.success(image))
            } else {
                result(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            result(.failure(NSError(domain: "", code: 0, userInfo: nil)))
        }
    }
}


struct SetPaper_Previews: PreviewProvider {
    static var previews: some View {
//        SetPaper(f_id: 1, f_name: "", c_id: 1, c_title: "", c_code: "", p_id: 1)
        StartMakingPaper(f_id: 1, f_name: "", c_id: 1, c_title: "", c_code: "")
    }
}



//        guard selectedClo != 0 else {
//            print("No CLO selected")
//            return
//        }
//
//        let selectedCLOID = selectedClo
//
//        guard let selectClo = cloViewModel.existing.first(where: { Int($0.clo_id) == selectedCLOID }) else {
//            print("Selected CLO not found")
//            return
//        }

