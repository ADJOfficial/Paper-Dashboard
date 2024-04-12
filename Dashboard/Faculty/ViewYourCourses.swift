//
//  ViewYourCourses.swift
//  Director Dashboard
//
//  Created by ADJ on 14/01/2024.
//

import SwiftUI

struct ViewYourCourses: View { // Design 100% OK
    
    var f_id: Int
    var f_name: String
    var c_id: Int
    var c_title: String
    var c_code: String
    var p_id: Int
    var t_id: Int
    var t_name: String
    @StateObject private var uploadedPaperViewModel = UploadedPaperViewModel()
    @StateObject private var assignedcoursesViewModel = AssignedCoursesViewModel()
    @StateObject private var  topicViewModel = TopicViewModel()
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        NavigationView {
            VStack{
                Text("Faculty")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                NavigationLink {
                    Mail(fb_details: "", f_id: f_id, c_id: c_id, c_title: c_title, c_code: c_code, f_name: f_name, q_id: 0, p_id: 0)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Image(systemName: "mail.fill")
                        .foregroundColor(Color.blue.opacity(0.7))
                }
                .padding()
                .font(.largeTitle)
                .frame(maxWidth: .infinity , alignment: .trailing)
                .padding(.horizontal)
                Spacer()
                Text("\(f_name) Assigned Courses")
//                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                VStack{
                    ScrollView{
                        ForEach(assignedcoursesViewModel.assignedCourses, id: \.self) { cr in
                            HStack{
                                NavigationLink{
                                    Subject(f_id: f_id, f_name: f_name, c_id: cr.c_id, c_title: cr.c_title, c_code: cr.c_code , p_id: p_id , t_id: t_id , t_name: t_name)
                                        .navigationBarBackButtonHidden(true)
                                }label: {
                                    Text(cr.c_title)
                                        .foregroundColor(.black)
                                        .padding()
                                        .bold()
                                        .frame(width: 170)
                                        .background(Color.green.opacity(0.8))
                                        .cornerRadius(8)
                                        .padding(.all)
                                }
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                        if assignedcoursesViewModel.assignedCourses.isEmpty {
                            Text("No Assigned Coursess Found")
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
                        .stroke(Color.green.opacity(0.5), lineWidth: 1)
                )
                .frame(height: 600)
                .onAppear {
                    assignedcoursesViewModel.fetchAssignedCourses(facultyID: f_id)
                }
                Spacer()
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fiii").resizable().ignoresSafeArea())
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

struct Subject: View {
    
    var f_id: Int
    var f_name: String
    var c_id: Int
    var c_title: String
    var c_code: String
    var p_id: Int
    var t_id: Int
    var t_name: String
    
    @StateObject private var uploadedPaperViewModel = UploadedPaperViewModel()
    var body: some View {
        
        NavigationView{
            VStack{
                Text("Course")
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
                VStack{
                    NavigationLink{
                        ViewTopics(f_id: f_id, c_id: c_id, c_title: c_title)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("View Topics")
                            .underline()
                    }
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(.all)
                    
                    NavigationLink{
                        CoveredTopics(f_id: f_id, c_id: c_id, c_code: c_code, c_title: c_title)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Covered Topic")
                            .underline()
                    }
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(.all)
                    
                    NavigationLink{
                        ViewCLOs(f_id: f_id, c_id: c_id, c_title: c_title)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("View CLOs")
                            .underline()
                    }
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(.all)
                    
                    NavigationLink{
                        SetPaper(f_id: f_id , f_name: f_name , c_id: c_id , c_title: c_title , c_code: c_code , p_id: p_id)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Set Paper")
                            .underline()
                    }
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(.all)
                    
                    NavigationLink{
                        PaperStatus(f_id: f_id, f_name: f_name, c_id: c_id, c_title: c_title)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Paper Status")
                            .underline()
                    }
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(.green)
                    .padding(.all)
                }
                Spacer()
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fiii").resizable().ignoresSafeArea())
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

struct ViewYourCourses_Previews: PreviewProvider {
    static var previews: some View {
//        Mail(fb_details: "", c_title: "", c_code: "", f_name: "", q_id: 1, p_id: 1)
//        ViewYourCourses(f_id: 0, c_id: 0, c_code: "", c_title: "", f_name: "")
        Subject(f_id: 1, f_name: "", c_id: 0, c_title: "", c_code: "" , p_id: 0 , t_id: 0, t_name: "")
    }
}



struct Mail: View {
    
    var fb_details: String
    var f_id: Int
    var c_id: Int
    var c_title: String
    var c_code: String
    var f_name: String
    var q_id: Int
    var p_id: Int
    
    @StateObject var feedbackViewModel = FeedbackViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Notifications")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                VStack {
                    ScrollView {
                        ForEach(feedbackViewModel.feedback.indices, id: \.self) { index in
                            let msg = feedbackViewModel.feedback[index]
                            VStack {
                                HStack{
                                    Text(msg.c_title)
                                        .foregroundColor(Color.yellow)
                                        .padding(.horizontal)
                                    Text(msg.c_code)
                                        .foregroundColor(Color.yellow)
                                        .padding(.horizontal)
                                }
                                .padding(5)
                                    Text(msg.fb_details)
                                        .font(.headline)
                                        .foregroundColor(Color.white)
                                        .padding(.horizontal)
                            }
                            Divider()
                                .background(Color.white)
                                .padding(2)
                        }
                        if feedbackViewModel.feedback.isEmpty {
                            Text("No Mail Found For \(f_name)")
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
                        .stroke(Color.green.opacity(0.5), lineWidth: 1)
                )
                .frame(height: 770)
                .onAppear {
                    feedbackViewModel.fetchExistingFeedback(facultyID: f_id, courseID: c_id)
                }
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fiii").resizable().ignoresSafeArea().aspectRatio(contentMode: .fill))
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
