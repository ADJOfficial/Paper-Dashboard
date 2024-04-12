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
    var option = ["2020" , "2021" , "2022" , "2023" , "2024"]
    
//    @StateObject private var uploadedpaperViewModel = UploadedPaperViewModel()
    @State private var paperStatus: String = ""
    
    @State private var showAlert = false
    
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
                            Text("Teacher")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            Text("\(f_name)")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .center)
                                .font(.title3)
                                .foregroundColor(Color.white)
                        }
                        .padding(2)
                        
                        HStack{
                            Text("Course Title")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            Text("\(c_title)")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .center)
                                .font(.title3)
                                .foregroundColor(Color.white)
                        }
                        .padding(2)
                        
                        HStack{
                            Text("Course Code")
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
                                .font(.title3)
                                .foregroundColor(Color.white)
                        }
                        .padding(2)
                        
                        HStack {
                            Text("Paper Name :")
                                .bold()
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .font(.title3)
                                .foregroundColor(Color.white)
                            TextField("" , text: $paperSetting.paperName)
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
                        
                        VStack{
                            HStack{
                                Text("Total Marks :")
                                    .bold()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                TextField("" , value: $paperSetting.totalMarks, formatter: NumberFormatter())
                                    .background(Color.gray.opacity(0.8))
                                    .cornerRadius(8)
                                    .frame(width: 180 , height: 20)
                                    .padding(.horizontal)
                            }
                            .padding(2)
                            
                            VStack{
                                Text("Semester :")
                                    .bold()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                HStack{
                                    Spacer()
                                    SemesterRadioButton(title: "Fall", isSelected: selectedSemRadioButton == "Fall") {
                                        selectedSemRadioButton = "Fall"
                                    }
                                    .foregroundColor(selectedSemRadioButton == "Fall" ? .green : .white)
                                    Spacer()
                                    SemesterRadioButton(title: "Spring", isSelected: selectedSemRadioButton == "Spring") {
                                        selectedSemRadioButton = "Spring"
                                    }
                                    .foregroundColor(selectedSemRadioButton == "Spring" ? .green : .white)
                                    Spacer()
                                    SemesterRadioButton(title: "Summer", isSelected: selectedSemRadioButton == "Summer") {
                                        selectedSemRadioButton = "Summer"
                                    }
                                    .foregroundColor(selectedSemRadioButton == "Summer" ? .green : .white)
                                    Spacer()
                                }
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
                                Text("Questions :")
                                    .bold()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                TextField("" , text: $totalQuestions)
                                    .background(Color.gray.opacity(0.8))
                                    .cornerRadius(8)
                                    .frame(width: 180 , height: 20)
                                    .padding(.horizontal)
                            }
                            .padding(2)
                            
                            HStack{
                                Text("Year :")
                                    .bold()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                Picker("" ,selection: $selectedValue){
                                    ForEach(0..<option.count){ index in
                                        Text(option[index])
                                    }
                                }
                                .pickerStyle(.menu)
                                .accentColor(Color.green)
                                
                            }
                            .padding(2)
                        }
                    }
                    .padding()
                }
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
                        StartMakingPaper(f_id: f_id, f_name: f_name, c_id: c_id, c_title: c_title, c_code: c_code,paperName: paperSetting.paperName , exam_date: paperSetting.examDate , degree: paperSetting.degree , duration: paperSetting.duration , totalMarks: paperSetting.totalMarks, p_id: p_id, t_id: 0)
                    }label: {
                        Image(systemName: "arrow.right.square.fill")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color.green)
                    }
                    Spacer()
                }
                
            }
            .background(Image("fiii").resizable().ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Paper Header Created"), message: Text("Click on Arrow Button To Start Making Paper Questions"), dismissButton: .default(Text("OK")))
            }
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
            "year": option[selectedValue],
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
    var paperName: String
    var exam_date: String
    var degree: String
    var duration: Int
    var totalMarks: Int
    var p_id: Int
    var t_id: Int
//    var status: String
    
//    @StateObject private var uploadedpaperViewModel = UploadedPaperViewModel()
//    @State private var paperStatus: String = ""
    
    @State private var showAlert = false
    
    
    @State private var q_marks = ""
    @State private var selectedDifficulty = 0
    var options = ["EASY" , "HARD" , "MEDIUM"]
   

    @State private var selectedClo: Int?
    @State private var selectedTopic: Int?
    
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    
    
    @State private var questions = ""
    
    @StateObject private var questionViewModel = QuestionViewModel()
    
    @StateObject private var  topicViewModel = TopicViewModel()
    @StateObject private var  cloViewModel = CLOViewModel()
    
    var body: some View {
        VStack{
            Text("Paper")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
//            Spacer()
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
            ScrollView{
                HStack{
                    VStack{
                        Text("Course Title: \(c_title)")
                            .bold()
                            .padding(.all,1)
                            .frame(maxWidth: .infinity , alignment: .leading)
                        Text("Date of Exam: \(exam_date)")
                            .bold()
                            .padding(.all,1)
                            .frame(maxWidth: .infinity , alignment: .leading)
                        Text("Degree Program: \(degree)")
                            .bold()
                            .padding(.all,1)
                            .frame(maxWidth: .infinity , alignment: .leading)
                        Text("Teacher Name: \(f_name)")
                            .bold()
                            .padding(.all,1)
                            .frame(maxWidth: .infinity , alignment: .leading)
                    }
                    VStack{
                        Text("Course Code: \(c_code)")
                            .bold()
                            .padding(.all,1)
                            .frame(maxWidth: .infinity , alignment: .leading)
                        Text("Duration: \(duration)")
                            .bold()
                            .padding(.all,1)
                            .frame(maxWidth: .infinity , alignment: .leading)
                        Text("Total Marks: \(totalMarks)")
                            .bold()
                            .padding(.all,1)
                            .frame(maxWidth: .infinity , alignment: .leading)
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
                VStack{
                    HStack{
                        Text("Question")
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity , alignment: .leading)
                        Text("CLO :")
                            .foregroundColor(Color.white)
                        Picker(selection: $selectedClo, label: Text("")) {
                            Text("CLOs").tag(nil as Int?)
                            ForEach(cloViewModel.existing, id: \.clo_id) { clo in
                                Text(clo.clo_text)
                                    .tag(clo.clo_id as Int?)
                            }
                        }
                        .accentColor(Color.green)
                        .onChange(of: (selectedClo)) { selectedCloID in
                            if let selectedCLOID = selectedCloID {
                                print("Selected CLO ID: \(selectedCLOID)")
                            }
                        }
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
                            .foregroundColor(Color.white)
                        Picker(selection: $selectedTopic, label: Text("")) {
                            Text("Topics").tag(nil as Int?)
                            ForEach(topicViewModel.existing, id: \.t_id) { topic in
                                Text(topic.t_name)
                                    .tag(topic.t_id as Int?)
                            }
                        }
                        .accentColor(Color.green)
                        .onChange(of: (selectedTopic)) { selectedTopicID in
                            if let selectedTopicID = selectedTopicID {
                                print("Selected topic ID: \(selectedTopicID)")
                            }
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
                        Image(systemName: "bolt.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.green)
                            .onTapGesture {
                                createQuestion()
                                showAlert
                            }
                        Spacer()
                    }
                    Spacer()
                    VStack{
                        ScrollView {
                            ForEach(questionViewModel.uploadedQuestions.indices, id: \.self) { index in
                                let cr = questionViewModel.uploadedQuestions[index]
                                VStack{
                                    Text("Question # 0\(index + 1)")
                                        .font(.headline)
                                        .foregroundColor(Color.orange)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(cr.q_text)
                                        .font(.headline)
                                        .foregroundColor(Color.white)
                                        .frame(maxWidth: .infinity , alignment: .leading)
                                    Text("[ \(cr.q_difficulty) , \(cr.q_marks) , \(cr.clo_code) ]")
                                        .font(.title3)
                                        .padding(.horizontal)
                                        .foregroundColor(Color.yellow)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                Divider()
                                    .background(Color.white)
                                .padding(1)
                            }
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
                    .onAppear{
                        questionViewModel.getPaperQuestions(paperID: p_id)
                    }
                }
                .onAppear{
                    topicViewModel.getCourseTopic(courseID: c_id)
                }
                .onAppear{
                    cloViewModel.getCourseCLO(courseID: c_id)
                }
//            Spacer()
        }
        .background(Image("fiii").resizable().ignoresSafeArea())
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerView(result: handleImagePickerResult)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Question Created Successfully"), message: Text("Click on Plus Button Below To Add More Question For This Paper if You Want..."), dismissButton: .default(Text("OK")))
        }
    }
    
    func createQuestion() {
        guard let url = URL(string: "http://localhost:4000/ifimageornot") else {
            return
        }
        
        guard selectedTopic != 0 else {
            print("No topic selected")
            return
        }

        let selectedTopicID = selectedTopic

        guard let selectTopic = topicViewModel.existing.first(where: { Int($0.t_id) == selectedTopicID }) else {
            print("Selected topic not found")
            return
        }
        guard selectedClo != 0 else {
            print("No CLO selected")
            return
        }

        let selectedCLOID = selectedClo

        guard let selectClo = cloViewModel.existing.first(where: { Int($0.clo_id) == selectedCLOID }) else {
            print("Selected CLO not found")
            return
        }
        
        let question = [
            "q_text": questions,
            "q_marks": q_marks,
            "q_difficulty": options[selectedDifficulty],
            "t_id": selectTopic.t_id,
            "p_id": p_id,
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
                    questionViewModel.getPaperQuestions(paperID: p_id)
                    showAlert = true
                    DispatchQueue.main.async {
                        questions = ""
                        selectedDifficulty = 0
                        q_marks = ""
                        selectedImage = nil
                        selectedClo = nil
                        selectedTopic = nil
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
        StartMakingPaper(f_id: 1, f_name: "", c_id: 1, c_title: "", c_code: "", paperName: "", exam_date: "", degree: "", duration: 0, totalMarks: 0, p_id: 1, t_id: 1)
    }
}
