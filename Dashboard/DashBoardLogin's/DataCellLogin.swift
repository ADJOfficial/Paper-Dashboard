//
//  DataCellLogin.swift
//  Director Dashboard
//
//  Created by ADJ on 11/01/2024.
//

import SwiftUI

struct DataCellLogin: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    
    var body: some View {
        VStack{
            Text("DataCell")
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
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Text("Password")
                    .bold()
                    .font(.title3)
                    .padding(.leading)
                    .foregroundColor(Color.white)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.bottom,220)
            }
            Button("Login"){
                login()
            }
            .foregroundColor(Color.black)
            .padding()
            .frame(width: 150, height: 60)
            .background(Color.yellow)
            .cornerRadius(8)
        }
        .fullScreenCover(isPresented: $isLoggedIn){
            DataCellWelcome(username: username)
                .navigationBarBackButtonHidden(true)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Failed"), message: Text("Username or Password is incorrect"), dismissButton: .default(Text("OK")))
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fw").resizable().ignoresSafeArea())
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
        if username == "Nadeem" &&  password == "123" {
            isLoggedIn = true
            print("Login Successfull")
        }
        else {
            print("Invalid Credentials")
            showAlert = true
        }
    }
}

struct DataCellLogin_Previews: PreviewProvider {
    static var previews: some View {
        DataCellLogin()
    }
}
