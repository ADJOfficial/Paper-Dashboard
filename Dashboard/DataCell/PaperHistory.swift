//
//  PaperHistory.swift
//  Dashboard
//
//  Created by ADJ on 23/06/2024.
//

import SwiftUI

struct PaperHistory: View {
    
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
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Papers History")
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
struct PaperHistory_Previews: PreviewProvider {
    static var previews: some View {
        PaperHistory()
    }
}
