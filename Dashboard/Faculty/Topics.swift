//
//  Topics.swift
//  Director Dashboard
//
//  Created by ADJ on 14/01/2024.
//

import SwiftUI

struct Topics: View { // Design 100% Ok
    
    @State private var Topic = ""
    @State private var clos = ""
    @State private var searchTopic = ""
    @State private var selectedOptions = 0
    var options = ["CS", "WT" , "SNA" , "SE" , "Isl" , "SRE"]
//    @StateObject var userViewModel = UserViewModel()
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        NavigationView{
            VStack{
                Text("Add Topics")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                Text("Course")
                    .bold()
//                    .padding()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                Picker("" , selection: $selectedOptions){
                    ForEach(0..<options.count) { index in
                        Text(options[index])
                    }
                }
                .accentColor(.green)
                .pickerStyle(.menu)
                Text("Topic")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                TextField("Username" , text: $Topic)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal)
                Spacer()
                VStack{
                    Text("CLOs")
                        .bold()
                        .padding()
//                        .padding(.horizontal)
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .center)
                    HStack {
                        Text("CLO:1")
                        Image(systemName: "square")
                        Text("CLO:2")
                        Image(systemName: "checkmark.square")
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Text("CLO:3")
                        Image(systemName: "square")
                        Text("CLO:4")
                        Image(systemName: "checkmark.square")
                            .foregroundColor(.green)
                    }
                    TextField("Search Teacher" , text: $searchTopic)
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(8)
                        .frame(width: 300)
                }
                .padding()
                .font(.headline)
                .foregroundColor(Color.white)
//                VStack {
//                    ScrollView{
//                        ForEach( , id:\ .self) { cr in
//                            HStack{
//                                Text(cr.name)
//                                    .font(.headline)
////                                    .padding(.horizontal)
//                                    .foregroundColor(Color.white)
//                                    .frame(maxWidth: .infinity , alignment: .leading)
//                                NavigationLink{
////                                    EditSubTopics()
////                                        .navigationBarBackButtonHidden(true)
//                                }label: {
//                                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
//                                        .font(.title2)
//                                        .foregroundColor(Color.green)
//                                        .frame(maxWidth: .infinity , alignment: .trailing)
//                                }
//                                    Image(systemName: "trash.fill")
//                                        .font(.title3)
////                                        .padding(.horizontal)
//                                        .foregroundColor(Color.red)
//                                NavigationLink{
////                                    AddSubTopics()
//                                }label: {
//                                    Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
//                                        .font(.title3)
//                                        .foregroundColor(Color.orange)
//                                }
//                            }
//                            Divider()
//                                .background(Color.white)
//                            .padding(1)
//                        }
//                    }
//                    .padding()
//                }
//                .border(.gray , width: 2)
//                .cornerRadius(5)
//                .frame(width: 410, height:150)
//                .onAppear {
////                    userViewModel.fetchExistingUser()
//                }
                Button("Create"){
                    saveTopic()
                }
                .bold()
                .padding()
                .frame(width: 150)
                .foregroundColor(.black)
                .background(Color.green)
                .cornerRadius(8)
                .padding(.all)
            }
            .background(Image("fiii").resizable().ignoresSafeArea())
        }
    }
    func saveTopic() {
        
    }
}

struct Topics_Previews: PreviewProvider {
    static var previews: some View {
        Topics()
    }
}
