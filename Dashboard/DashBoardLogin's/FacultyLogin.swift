//
//  FacultyLogin.swift
//  Director Dashboard
//
//  Created by ADJ on 11/01/2024.
//

import SwiftUI

struct FacultyLogin: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false

    @StateObject private var facultiesViewModel = FacultiesViewModel()
    @StateObject private var uploadedPaperViewModel = UploadedPaperViewModel()
    @StateObject private var  topicViewModel = TopicViewModel()
    
    var topic: Topic
    var body: some View {
        VStack {
            Text("Faculty")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.white)
            Spacer()
            VStack(alignment: .leading) {
                Text("Username")
                    .bold()
                    .font(.title3)
                    .padding(.leading)
                    .foregroundColor(Color.white)
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8)
                    .padding(.horizontal)

                Text("Password")
                    .bold()
                    .font(.title3)
                    .padding(.leading)
                    .foregroundColor(Color.white)
                TextField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Spacer()
            Button(action: {
                login()
            }) {
                Text("Login")
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(width: 150, height: 60)
                    .background(Color.green.opacity(0.8))
                    .cornerRadius(8)
            }
            .onAppear {
                facultiesViewModel.fetchExistingFaculties()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid credentials"), message: Text("Please enter valid username and password"), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $isLoggedIn) {
                if let faculty = facultiesViewModel.remaining.first(where: { $0.username == username }) {
                    FacultyWelcome(facultyName: faculty.f_name , f_id: faculty.f_id, p_id: 0,t_id: topic.t_id)
                }
            }
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fiii").resizable().ignoresSafeArea())
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

    func login() {
        facultiesViewModel.login(username: username, password: password) { isLoggedIn in
            if isLoggedIn {
                self.isLoggedIn = true
            } else {
                showAlert = true
            }
        }
    }
}

struct FacultyLogin_Previews: PreviewProvider {
    static var previews: some View {
        FacultyLogin(topic: Topic(t_id: 0, t_name: "", status: ""))
    }
}
