//
//  DirectorLogin.swift
//  Director Dashboard
//
//  Created by ADJ on 11/01/2024.
//

import SwiftUI

struct DirectorLogin: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var showPassword: Bool = false

    var body: some View {
        VStack{
            Text("Director")
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
                VStack {
                    if showPassword {
                        TextField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    } else {
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .padding()
                            .font(.title3)
                            .frame(maxWidth: .infinity , alignment: .trailing)
                            .foregroundColor(.gray)
                    }
                }
            }
            Spacer()
            Button("Login"){
                login()
            }
            .foregroundColor(Color.black)
            .padding()
            .frame(width: 150, height: 60)
            .background(Color.brown.opacity(0.7))
            .cornerRadius(8)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid credentials"), message: Text("Please enter valid username and password"), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $isLoggedIn){
           DirectorWelcome(username: username)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Failed"), message: Text("Username or Password is incorrect"), dismissButton: .default(Text("OK")))
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
    
    func login() {
        if username == "Dr Jamil" &&  password == "sawaar@786" {
            isLoggedIn = true
            print("Login Successfull")
            
        }
        else {
            print("Invalid Credentials")
            showAlert = true
        }
    }
}

struct DirectorLogin_Previews: PreviewProvider {
    static var previews: some View {
        DirectorLogin()
    }
}
