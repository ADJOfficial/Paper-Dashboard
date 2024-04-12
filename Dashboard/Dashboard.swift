//
//  SelectRole.swift
//  Director Dashboard
//
//  Created by ADJ on 11/01/2024.
//

import SwiftUI

struct Dashboard: View {
    
    @State private var animate = false
    
    var body: some View {
        
        NavigationView {
            VStack{
                Text("Director Dashboard")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .foregroundColor(.blue)
                Spacer()
                Text("What's Your Role")
                    .bold()
                    .font(.title2)
                    .padding()
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .leading)
                    .scaleEffect(animate ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2)) {
                            animate = true
                        }
                    }
                VStack{
                    
                    NavigationLink{
                        DirectorLogin()
                            .navigationBarBackButtonHidden(true)
                    }label: {
                        Text("Director")
                            .foregroundColor(.black)
                            .padding()
                            .bold()
                            .frame(width: 150)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.all)
                            .blur(radius: animate ? 0 : 10)
                    }
                    NavigationLink{
                        HODLogin()
                            .navigationBarBackButtonHidden(true)
                    }label: {
                        Text("HOD")
                            .foregroundColor(.black)
                            .padding()
                            .bold()
                            .frame(width: 150)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.all)
                            .blur(radius: animate ? 0 : 10)
                    }
                    NavigationLink{
                        FacultyLogin(topic: Topic(t_id: 0, t_name: "", status: ""))
                    }label: {
                        Text("Faculty")
                            .foregroundColor(.black)
                            .padding()
                            .bold()
                            .frame(width: 150)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.all)
                            .blur(radius: animate ? 0 : 10)
                    }
                    NavigationLink{
                        DataCellLogin()
                            .navigationBarBackButtonHidden(true)
                    }label: {
                        Text("Data Cell")
                            .foregroundColor(.black)
                            .padding()
                            .bold()
                            .frame(width: 150)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.all)
                            .blur(radius: animate ? 0 : 10)
                    }
                }
                Text("Welcome to the Director Dashboard! The Director Dashboard is a powerful tool that provides you with valuable insights and control over your organization's operations. With this dashboard, you can easily monitor key performance indicators, track project progress, and make informed decisions to drive your team's success.")
                    .multilineTextAlignment(.center)
                    .fontWeight(.thin)
                    .font(.custom("HelveticaNeue-Bold", size: 20))
                    .foregroundColor(Color.gray)
            }
            .background(Image("fa").resizable().ignoresSafeArea())
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}


// Table Bar Controller
