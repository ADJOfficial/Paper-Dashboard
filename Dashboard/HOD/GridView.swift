//
//  GridView.swift
//  Director Dashboard
//
//  Created by ADJ on 13/01/2024.
//

import SwiftUI

struct GridView: View { // Design 100% ok
    
    @State private var SelectedOption = 0
    var options = ["Cyber Security" , "Communication Skills" , "Software engeenring"]
    
    @State private var weight = ""
    @State private var clo1 = ""
    @State private var clo2 = ""
    @State private var clo3 = ""
    @State private var clo4 = ""
    @State private var clo5 = ""
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        VStack {
           Spacer()
            Text("Grid")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Text("Course")
                .bold()
                .padding()
                .font(.title3)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Picker("Selected" , selection: $SelectedOption){
                ForEach(0..<options.count) { index in
                    Text(options[index])
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.8))
            .cornerRadius(8)
            .padding(.horizontal)
            Text("Assessments")
                .font(.title3)
                .cornerRadius(8)
                .foregroundColor(Color.yellow)
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Text("Assignments")
                    Spacer()
                    Text("Quizs")
                    Spacer()
                    Text("Mid Term")
                    Spacer()
                    Text("Final Term")
                    Spacer()
                }
                .foregroundColor(Color.white)
                HStack{
                    Spacer()
                    TextField("", text: $weight)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $weight)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $weight)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $weight)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                }
                Rectangle()
                    .frame(height: 2)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                HStack{
                    Spacer()
                    TextField("", text: $clo1)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo1)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo1)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo1)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                }
                HStack{
                    Spacer()
                    TextField("", text: $clo2)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo2)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo2)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo2)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                }
                HStack{
                    Spacer()
                    TextField("", text: $clo3)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo3)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo3)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo3)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                }
                HStack{
                    Spacer()
                    TextField("", text: $clo4)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo4)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo4)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo4)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                }
                HStack{
                    Spacer()
                    TextField("", text: $clo5)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo5)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo5)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                    TextField("", text: $clo5)
                        .frame(width: 50, height: 40)
                        .background(Color.white)
                        .cornerRadius(10)
                    Spacer()
                }
                Spacer()
            }
            Text("Weight <= 100")
                .padding()
                .font(.title3)
                .foregroundColor(Color.red)
                .frame(maxWidth: .infinity , alignment: .leading)
            Button("Save"){
                
            }
            .bold()
            .padding()
            .frame(width: 100)
            .foregroundColor(.black)
            .background(Color.teal)
            .cornerRadius(8)
            .padding(.bottom)
            Spacer()
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fc").resizable().ignoresSafeArea())
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

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
