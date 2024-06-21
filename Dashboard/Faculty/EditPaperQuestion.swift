////
////  EditPaperQuestion.swift
////  Dashboard
////
////  Created by ADJ on 19/06/2024.
////
//
//import SwiftUI
//
//struct EditPaperQuestion: View {
//
//    var c_id: Int
//    var c_title: String
//    var c_code: String
//
////    @Binding var savedTopic: Int
//
//    @State private var question = ""
//    @State private var q_marks = ""
//    @State private var selectedDifficulty = 0
//    var options = ["Easy" , "Hard" , "Medium"]
//    @State private var selectedTopic: Int?
//    @State private var selectedImage: UIImage?
//    @State private var isShowingImagePicker = false
//
//    @StateObject private var  topicViewModel = TopicViewModel()
//    @StateObject private var  topiccloViewModel = TopicCLOViewModel()
//
//    var questions: GetPaperQuestions
//
//    var body: some View {
//        VStack {
//            Text("Edit Question")
//                .bold()
//                .font(.largeTitle)
//                .foregroundColor(Color.white)
//            Spacer()
//            Text("Course")
//                .bold()
//                .padding(.horizontal)
//                .font(.title2)
//                .foregroundColor(Color.white)
//                .frame(maxWidth: .infinity , alignment: .leading)
//            Text("\(c_title)")
//                .font(.title3)
//                .padding()
//                .frame(maxWidth: .infinity , alignment: .center)
//                .foregroundColor(Color.white)
//            Text("Course Code")
//                .bold()
//                .padding(.horizontal)
//                .font(.title2)
//                .foregroundColor(Color.white)
//                .frame(maxWidth: .infinity , alignment: .leading)
//            Text("\(c_code)")
//                .font(.title3)
//                .padding()
//                .frame(maxWidth: .infinity , alignment: .center)
//                .foregroundColor(Color.white)
//            VStack {
//                Text("Question")
//                    .padding(.horizontal)
//                    .font(.headline)
//                    .foregroundColor(Color.white)
//                    .frame(maxWidth: .infinity , alignment: .leading)
//                TextField("Enter Question" , text: $question)
//                    .padding()
//                    .foregroundColor(Color.black)
//                    .background(Color.gray.opacity(1))
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//                    .onAppear{
//                        question = questions.q_text
//                    }
//                HStack{
//                    Text("Difficulty :")
//                        .padding(.horizontal)
//                        .foregroundColor(Color.white)
//                    Picker("" , selection: $selectedDifficulty) {
//                        ForEach(0..<options.count) {index in
//                            Text(options[index])
//                        }
//                    }
////                    .onAppear{
////                        selectedDifficulty = Int(questions.q_difficulty)
////                    }
//                    .accentColor(Color.green)
//                    Spacer()
//                    Text("Topic :")
//                        .foregroundColor(Color.white)
//                    Picker(selection: $selectedTopic, label: Text("")) {
//                                Text("Topics").tag(nil as Int?)
//                                ForEach(topicViewModel.existing, id: \.t_id) { topic in
//                                    Text(topic.t_name)
//                                        .tag(topic.t_id as Int?)
//                                }
//                            }
//                            .onAppear {
//                                if let t_nameInt = Int(questions.t_name) {
//                                    selectedTopic = t_nameInt
//                                } else {
//                                    // Handle the case where the conversion fails
//                                    selectedTopic = nil
//                                }
//                            }
//                            .accentColor(Color.green)
//                            .onChange(of: selectedTopic) { selectedTopicID in
//                                if let selectedTopicID = selectedTopicID {
//                                    print("Selected topic ID: \(selectedTopicID)")
//                                    topiccloViewModel.getTopicCLO(topicID: selectedTopicID)
//                                }
//                            }
//
//                            // Display the CLOs for the selected topic
//                            ForEach(topiccloViewModel.topicCLO, id: \.self) { clo in
//                                Text(clo.clo_code)
//                            }
//                }
//                HStack {
//                    Spacer()
//
//                    if let image = selectedImage {
//                        Image(uiImage: image)
//                            .resizable()
//                            .cornerRadius(30)
//                            .frame(width: 100, height: 100)
//                    } else {
//                        Image(systemName: "photo.fill")
//                            .font(.largeTitle)
//                            .foregroundColor(Color.green)
//                            .onTapGesture {
//                                presentImagePicker()
//                            }
//                    }
//                    Spacer()
//                    Text("Marks :")
//                        .font(.title3)
//                        .foregroundColor(Color.white)
//                    TextField("Marks", text: $q_marks)
//                        .padding()
//                        .foregroundColor(Color.black)
//                        .background(Color.gray.opacity(1))
//                        .cornerRadius(8)
//                        .frame(width: 80)
//                        .padding(.horizontal)
//                        .onAppear{
//                            q_marks = String(questions.q_marks)
//                        }
//                    Spacer()
//                    Button("Update"){
////                        createQuestion()
////                        showAlert
//                    }
//                    .bold()
//                    .padding()
//                    .foregroundColor(.black)
//                    .background(Color.green)
//                    .cornerRadius(8)
//                    .frame(width: 100)
//                    //                            .padding(.horizontal)
//                    .frame(alignment: .trailing)
//                    Spacer()
//                }
//
//            }
//            .onAppear{
//                topicViewModel.getCourseTopic(courseID: c_id)
//            }
//
//            Spacer()
//        }
//        .navigationBarItems(leading: backButton)
//        .background(Image("fiii").resizable().ignoresSafeArea())
//    }
//    @Environment(\.presentationMode) var presentationMode
//    private var backButton: some View {
//        Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.blue)
//                .imageScale(.large)
//        }
//    }
//    func presentImagePicker() {
//        isShowingImagePicker = true
//    }
//}
//
//struct EditPaperQuestion_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPaperQuestion(c_id: 1, c_title: "", c_code: "", questions: GetPaperQuestions(q_id: 0, q_text: "", q_marks: 0, q_difficulty: "", q_verification: "", p_id: 0, c_id: 0, c_code: "", c_title: "", f_id: 0, f_name: "", t_name: "", clo_code: "", clo_text: ""))
//    }
//}
import SwiftUI

struct EditPaperQuestion: View {
    @ObservedObject var viewModel: EditQuestionViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Question Details")) {
                TextField("Question Text", text: $viewModel.question.q_text)
                
                HStack {
                    Text("Difficulty:")
                    Picker("", selection: $viewModel.selectedDifficulty) {
                        ForEach(0..<viewModel.options.count, id: \.self) { index in
                            Text(viewModel.options[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                HStack {
                    Text("Topic:")
                    Picker("", selection: $viewModel.selectedTopic) {
                        Text("Select Topic").tag(nil as Int?)
                        ForEach(viewModel.topics, id: \.t_id) { topic in
                            Text(topic.t_name).tag(topic.t_id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                TextField("Marks", value: $viewModel.question.q_marks, formatter: NumberFormatter())
                TextField("CLO Code", text: $viewModel.question.clo_code)
                TextField("CLO Text", text: $viewModel.question.clo_text)
            }
            
            Button(action: {
                viewModel.saveChanges()
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Edit Question")
        .navigationBarTitleDisplayMode(.inline)
    }
}

