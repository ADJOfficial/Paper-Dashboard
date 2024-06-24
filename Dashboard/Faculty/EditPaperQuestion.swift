////
////  EditPaperQuestion.swift
////  Dashboard
////
////  Created by ADJ on 19/06/2024.
////
//
import SwiftUI

struct EditPaperQuestion: View {
    
    var f_id: Int
    var p_id: Int
    var c_id: Int
    var c_title: String
    var c_code: String
    
    //    @Binding var savedTopic: Int
    
    @State private var q_text = ""
    @State private var q_marks = ""
    @State private var selectedDifficulty = 0
    var options = ["Easy" , "Hard" , "Medium"]
    @State private var selectedTopic: Int?
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var showAlert = false
    
    @StateObject private var  topicViewModel = TopicViewModel()
    @StateObject private var  topiccloViewModel = TopicCLOViewModel()
    @StateObject private var questionViewModel = QuestionViewModel()
    var questions: GetPaperQuestions
    
    var body: some View {
        VStack {
            Text("Edit Question")
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
            Text("Course Code")
                .bold()
                .padding(.horizontal)
                .font(.title2)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            Text("\(c_code)")
                .font(.title3)
                .padding()
                .frame(maxWidth: .infinity , alignment: .center)
                .foregroundColor(Color.white)
            VStack {
                Text("Question")
                    .padding(.horizontal)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                TextField("Enter Question" , text: $q_text)
                    .padding()
                    .foregroundColor(Color.black)
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .onAppear{
                        q_text = questions.q_text
                    }
                HStack{
                    Text("Difficulty :")
                        .padding(.horizontal)
                        .foregroundColor(Color.white)
                    Picker("" , selection: $selectedDifficulty) {
                        ForEach(0..<options.count) {index in
                            Text(options[index])
                        }
                    }
                    //                    .onAppear{
                    //                        selectedDifficulty = Int(questions.q_difficulty)
                    //                    }
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
                    .onAppear {
                        selectedTopic = questions.t_id
                        topicViewModel.getCourseTopic(courseID: c_id)
                    }
                    .accentColor(Color.green)
                    .onChange(of: selectedTopic) { selectedTopicID in
                        if let selectedTopicID = selectedTopicID {
                            topiccloViewModel.getTopicCLO(topicID: selectedTopicID)
                        }
                    }
                    
                    // Display the CLOs for the selected topic
                    ForEach(topiccloViewModel.topicCLO, id: \.self) { clo in
                        Text(clo.clo_code)
                    }
                }
                HStack {
                    Spacer()
                    VStack{
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
                    }
                    .onAppear {
                        if let base64String = questions.imageData, let imageData = Data(base64Encoded: base64String), let image = UIImage(data: imageData) {
                            selectedImage = image
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
                        .onAppear{
                            q_marks = String(questions.q_marks)
                        }
                    Spacer()
                    Button("Update"){
                        updateQuestion()
                    }
                    .bold()
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.green)
                    .cornerRadius(8)
                    .frame(width: 100)
                    //                            .padding(.horizontal)
                    .frame(alignment: .trailing)
                    Spacer()
                }
                
            }
            .onAppear{
                topicViewModel.getCourseTopic(courseID: c_id)
            }
            
            Spacer()
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fiii").resizable().ignoresSafeArea())
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerView(result: handleImagePickerResult)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Question Updated Successfully"), message: Text("Go Back To Update Any Other Question"), dismissButton: .default(Text("OK")))
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
    
    func updateQuestion() {
        guard let url = URL(string: "http://localhost:4000/updatequestion1/\(questions.q_id)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        guard let selectClo = topiccloViewModel.topicCLO.first else {
            print("CLO not found for selected topic")
            return
        }
        
        // Add other updated question fields
        var updatedQuestion: [String: Any] = [
            "q_text": q_text,
            "q_marks": q_marks,
            "q_difficulty": selectedDifficulty,
            "t_id": p_id, // Default value to avoid sending a null or invalid t_id
            "p_id": p_id,
            "f_id": f_id,
            "c_id": c_id,
            "clo_id": selectClo.clo_id
        ]
        
        // Unwrap and convert selectedTopic to Int if it's not nil
        if let selectedTopicInt = selectedTopic.flatMap({ Int($0) }) {
            updatedQuestion["t_id"] = selectedTopicInt
        }
        
        for (key, value) in updatedQuestion {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        // Add image data if available
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.9) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"q_image\"; filename=\"image.jpeg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let message = responseJSON?["message"] as? String {
                    DispatchQueue.main.async {
                        // alertMessage = message
                        showAlert = true
                    }
                }
            } catch {
                print("Error while decoding response data: \(error)")
            }
        }
        task.resume()
    }
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
//struct EditPaperQuestion_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPaperQuestion(f_id:0 , p_id: 0 ,  c_id: 0, c_title: "", c_code: "", questions: GetPaperQuestions(q_id: 0, q_text: "", q_marks: 0, q_difficulty: "", q_verification: "", p_id: 0, c_id: 0, c_code: "", c_title: "", f_id: 0, f_name: "", t_id: 0, t_name: "", clo_code: "", clo_text: ""))
//    }
//}
