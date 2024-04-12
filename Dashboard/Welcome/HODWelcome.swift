//
//  HODWelcome.swift
//  Director Dashboard
//
//  Created by ADJ on 06/01/2024.
//

import SwiftUI

struct HODWelcome: View { // Design 100% OK
    
    let username: String
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        NavigationView{
            VStack {
                Text("HOD Dashboard")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("Welcome  \(username)")
                    .bold()
                    .padding()
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .leading)
                Spacer()
                VStack{
                    NavigationLink{
                        FacultyDetails()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Faculty Details")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 150)
                    .background(Color.teal.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.all)
                    
                    NavigationLink{
                        ViewCourses()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("View Courses")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 150)
                    .background(Color.teal.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.all)
                    
                    NavigationLink{
                        AssignCourse()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Assign Course")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 150)
                    .background(Color.teal.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.all)
                    
                    NavigationLink{
                        AssignRole()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Course Senior")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 150)
                    .background(Color.teal.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.all)
                    
                    NavigationLink{
                        GridView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Grid View")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 150)
                    .background(Color.teal.opacity(0.9))
                    .cornerRadius(8)
                    .padding(.all)
                }
                Spacer()
                
                NavigationLink{
                    HODLogin()
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
            .navigationBarItems(leading: backButton)
            .background(Image("fc").resizable().ignoresSafeArea())
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

struct HODWelcome_Previews: PreviewProvider {
    static var previews: some View {
        HODWelcome(username: "")
    }
}
