//
//  ApprovePaper.swift
//  Director Dashboard
//
//  Created by ADJ on 06/04/2024.
//

import SwiftUI

struct ApprovePaper: View {
    @State private var searchText = ""
//    @State private var searchResults: [GetUploadedPaper] = []
    @StateObject private var uploadedPaperViewModel = UploadedPaperViewModel()
//    @StateObject private var coursesViewModel = CoursesViewModel()
    
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
                        .font(.title3)
                        .foregroundColor(Color.red.opacity(0.9))
                }
                .opacity(text.isEmpty ? 0 : 1)
            }
        }
    }
    var body: some View { // Get All Data From Node MongoDB : Pending
        NavigationView {
            VStack {
                Text("Approved Papers")
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
                            VStack{
                                Text(cr.status)
                                    .bold()
                                    .foregroundColor(Color.green)
                                    .frame(maxWidth: .infinity , alignment: .trailing)
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
                                }
                                Divider()
                                    .background(Color.white)
                                    .padding(1)
                            }
                            .padding(5)
                        }
                        if filteredPapers.isEmpty {
                            Text("No Approved Papers Found")
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
                    uploadedPaperViewModel.fetchApprovedPapers()
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

struct ApprovePaper_Previews: PreviewProvider {
    static var previews: some View {
        ApprovePaper()
    }
}
