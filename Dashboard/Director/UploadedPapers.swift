//
//  UploadedPapers.swift
//  Director Dashboard
//
//  Created by ADJ on 16/03/2024.
//

import SwiftUI

struct UploadedPapers: View {
    
    
    @State private var searchText = ""
    @StateObject private var uploadedPaperViewModel = UploadedPaperViewModel()
    
    var filteredPapers: [GetUploadedPaper] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return uploadedPaperViewModel.uploaded
        } else {
            return uploadedPaperViewModel.uploaded.filter { faculty in
                faculty.c_title.localizedCaseInsensitiveContains(searchText) ||
                faculty.c_code.localizedCaseInsensitiveContains(searchText)
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
                        .foregroundColor(.gray)
//                        .padding(.horizontal)
                }
                .opacity(text.isEmpty ? 0 : 1)
            }
        }
    }
    var body: some View { // Get All Data From Node MongoDB : Pending
        NavigationView {
            VStack {
                Text("Uploaded Papers")
//                    .padding()
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)

                Spacer()
                SearchBar(text: $searchText)
                    .padding()
                
                VStack{
                    ScrollView {
                        ForEach(filteredPapers.indices, id: \.self) { index in
                            let cr = filteredPapers[index]
                            HStack{
                                Text(cr.c_title)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                Text(cr.c_code)
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .center)
                                NavigationLink{
                                    EyeViewPaperHeader(p_id: cr.p_id, f_id: cr.f_id, f_name: cr.f_name, c_id: cr.c_id, c_title: cr.c_title, c_code: cr.c_code, exam_date: cr.exam_date, duration: cr.duration, degree: cr.degree, term: cr.term, year: cr.year, t_marks: cr.t_marks, t_questions: cr.t_questions, q_id: 0 ,clo_text: "", t_name: "" )
                                        .navigationBarBackButtonHidden(true)
                                }label: {
                                    Image(systemName: "eye.fill")
                                        .bold()
                                        .font(.title3)
                                        .foregroundColor(Color.orange)
                                }
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                        if filteredPapers.isEmpty {
                            Text("No Uploaded Papers Found")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                )
                .frame(height:700)
                .onAppear {
                    uploadedPaperViewModel.fetchUploadedPapers()
                    print("Filtered Papers Count:", filteredPapers.count)
                }
                
                Spacer()
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
}

struct EyeViewPaperHeader: View { // Design 100% Ok

    var p_id:Int
    var f_id: Int
    var f_name: String
    var c_id: Int
    var c_title: String
    var c_code: String
    var exam_date: String
    var duration: Int
    var degree: String
    var term: String
    var year: Int
    var t_marks: Int
    var t_questions: Int
    var q_id: Int
    var clo_text: String
    var t_name: String
//    var q_text: String
//    var q_marks: Int
//    var q_difficulty: String
//    var status: String
    
    var body: some View { // Get All Data From Node MongoDB : Pending
    
        NavigationView {
            VStack{
                Text("Paper Information")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("\(c_title)")
                    .bold()
                    .font(.title2)
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                Text("\(c_code)")
                    .bold()
                    .font(.headline)
                    .padding(.horizontal)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                NavigationLink {
                    Comments(f_id: f_id, c_id: c_id, p_id: p_id, q_id: q_id, c_title: c_title, c_code: c_code)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Image(systemName: "text.bubble.fill")
                        .font(.largeTitle)
                        .padding(.horizontal)
                        .foregroundColor(Color.green)
                        .frame(maxWidth: .infinity , alignment: .trailing)
                }
                Spacer()
                VStack {
                    ScrollView{
                        HStack{
                            Text("Teacher :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(f_name)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Course Title :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(c_title)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Course Code :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(c_code)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Date of Exam :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(exam_date)")
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Duration :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(duration)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Degree :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(degree)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Term :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(term)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Year :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(year)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Total Marks :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(t_marks)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                        HStack{
                            Text("Questions :")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .leading)
                            Text("\(t_questions)")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity , alignment: .trailing)
                        }
                        .padding(3)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                )
                .frame(height: 450)
                Spacer()
                NavigationLink {
                    PaperQuestions(paperID: p_id, q_id: q_id, p_id: p_id, c_id: c_id, c_code: c_code, c_title: c_title, f_id: f_id, f_name: f_name, clo_text: clo_text, t_name: t_name, exam_date: exam_date, degree: degree, duration: duration, t_marks: t_marks)
                        .navigationBarBackButtonHidden(true)
                }label: {
                    Text("View Questions")
                }
                .foregroundColor(.black)
                .padding()
                .background(Color.brown.opacity(1))
                .cornerRadius(8)
                Spacer()
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
}

struct Comments: View { // Design 100% Ok
    
    var f_id: Int
    var c_id: Int
    var p_id: Int
    var q_id: Int
    var c_title: String
    var c_code: String
    @State private var fb_details: String = ""
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        VStack {
            Text("Comments")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            Text("\(c_title)")
                .bold()
                .font(.title2)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            Text("\(c_code)")
                .bold()
                .font(.headline)
                .padding(.horizontal)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity , alignment: .leading)
            Spacer()
            ZStack(alignment: .bottomTrailing) {
                TextEditor(text: $fb_details)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(height: 400)
                HStack {
                    Spacer()
                    Button(action: {
                        createFeedback()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .padding()
                            .font(.largeTitle)
                            .foregroundColor(Color.green)
                    }
                }
            }
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
    
    func createFeedback() {
        guard let url = URL(string: "http://localhost:3000/addfeedback") else {
            return
        }

        let user = [
            "f_id": f_id,
            "c_id": c_id,
            "p_id": p_id,
//            "q_id": q_id,
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
}


struct UploadedPapers_Previews: PreviewProvider {
    static var previews: some View {
        UploadedPapers()
    }
}
