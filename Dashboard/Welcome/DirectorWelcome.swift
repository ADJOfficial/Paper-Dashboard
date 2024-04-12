//
//  DirectorWelcome.swift
//  Director Dashboard
//
//  Created by ADJ on 06/01/2024.
//

import SwiftUI

struct DirectorWelcome: View { // Design 100% Ok
    
    let username: String
    
    var body: some View { // Get All Data From Node MongoDB : Pending
    
        NavigationView{
            VStack{
                Text("Director")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("Welcome \(username)")
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .leading)
                Spacer()
                VStack {
                    NavigationLink {
                        UploadedPapers()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Upload Papers")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 170)
                    .background(Color.brown.opacity(0.7))
                    .cornerRadius(8)
                    .padding(.all)
                    NavigationLink {
                        ApprovePaper()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Approved Papers")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 170)
                    .background(Color.brown.opacity(0.7))
                    .cornerRadius(8)
                    .padding(.all)
                }
                Spacer()
                
                NavigationLink{
                    DirectorLogin()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Logout ? ")
                }
                .bold()
                .padding()
                .padding(.horizontal)
                .foregroundColor(.teal)
                .frame(maxWidth: .infinity , alignment: .trailing)
            }
            .background(Image("ft").resizable().ignoresSafeArea())
        }
    }
}

struct DirectorWelcome_Previews: PreviewProvider {
    static var previews: some View {
        DirectorWelcome(username: "")
    }
}
