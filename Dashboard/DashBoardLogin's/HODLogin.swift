//
//  HODLogin.swift
//  Director Dashboard
//
//  Created by ADJ on 11/01/2024.
//

import SwiftUI

struct HODLogin: View {

    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Text("HOD")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.white)
            Spacer()
            VStack(alignment: .leading){
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
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Spacer()
            Button("Login"){
                login()
            }
            .foregroundColor(Color.black)
            .padding()
            .frame(width: 150, height: 60)
            .background(Color.teal.opacity(0.9))
            .cornerRadius(8)
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fc").resizable().ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid credentials"), message: Text("Please enter valid username and password"), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $isLoggedIn){
           HODWelcome(username: username)
        }
    }

    func login() {
        if username == "Dr Munir" &&  password == "123" {
            isLoggedIn = true
            print("Login Successfull")
        }
        else {
            print("Invalid Credentials")
        }
    }
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

struct HODLogin_Previews: PreviewProvider {
    static var previews: some View {
        HODLogin()
    }
}

//import SwiftUI
//
//struct ContentView: View {
//    @State private var username = ""
//    @State private var password = ""
//    @State private var showAlert = false
//
//    var body: some View {
//        VStack {
//            TextField("Username", text: $username)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            SecureField("Password", text: $password)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            Button(action: login) {
//                Text("Login")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//        }
//        .padding()
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Invalid credentials"), message: Text("Please enter valid username and password"), dismissButton: .default(Text("OK")))
//        }
//    }
//
//    func login() {
//        let url = URL(string: "http://localhost:8000/loginMembers")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let parameters: [String: Any] = [
//            "username": username,
//            "password": password
//        ]
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//               let message = responseJSON["message"] as? String {
//                // Login successful
//                print(message)
//            } else {
//                // Invalid credentials
//                showAlert = true
//            }
//        }.resume()
//    }
//}
//
//struct ContentVie_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
