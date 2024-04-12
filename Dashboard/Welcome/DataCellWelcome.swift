//
//  DataCellWelcome.swift
//  Director Dashboard
//
//  Created by ADJ on 06/01/2024.
//

import SwiftUI

struct DataCellWelcome: View { // Design 100% Ok
    
    let username: String
    
    var body: some View { // Get All Data From Node MongoDB : Pending
    
        NavigationView{
            VStack{
                Text("DataCell")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("Welcome \(username)")
                    .bold()
                    .padding()
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .leading)
                Spacer()
                VStack{
                    NavigationLink{
                        Faculty()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Faculty")
                    }
                    .bold()
                    .padding()
                    .frame(width: 160)
                    .foregroundColor(.black)
                    .background(Color.yellow)
                    .cornerRadius(8)
                    .padding(.all)
                    
                    NavigationLink{
                        Course()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Course")
                    }
                    .bold()
                    .padding()
                    .frame(width: 160)
                    .foregroundColor(.black)
                    .background(Color.yellow)
                    .cornerRadius(8)
                    .padding(.all)
                    
                    NavigationLink{
                        ApprovedPaper()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Approved Paper")
                    }
                    .bold()
                    .padding()
                    .frame(width: 160)
                    .foregroundColor(.black)
                    .background(Color.yellow)
                    .cornerRadius(8)
                    .padding(.all)
                    
                    NavigationLink{
                        PrintedPapers()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Printed Paper")
                    }
                    .bold()
                    .padding()
                    .frame(width: 160)
                    .foregroundColor(.black)
                    .background(Color.yellow)
                    .cornerRadius(8)
                    .padding(.all)
                }
                Spacer()
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fw").resizable().ignoresSafeArea())
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

struct DataCellWelcome_Previews: PreviewProvider {
    static var previews: some View {
        DataCellWelcome(username: "")
    }
}
