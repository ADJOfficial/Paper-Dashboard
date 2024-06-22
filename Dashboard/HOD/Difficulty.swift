//
//  Difficulty.swift
//  Dashboard
//
//  Created by ADJ on 02/06/2024.
//

import SwiftUI

struct Difficulty: View {
    
    @State private var easy = ""
    @State private var medium = ""
    @State private var hard = ""
    @State private var totalQuestions = ""
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Text("Manage Difficulty")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color.white)
            Spacer()
            VStack {
                Spacer()
                Text("Easy")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                HStack{
                    Text("Number of Easy Questions")
                        .bold()
                        .padding(.horizontal)
                        .font(.title3)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("E" , text: $easy)
                        .padding()
                        .frame(width: 50, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                Text("Medium")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                HStack{
                    Text("Number of Medium Questions")
                        .bold()
                        .padding(.horizontal)
                        .font(.title3)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("M" , text: $medium)
                        .padding()
                        .frame(width: 50, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                Text("Hard")
                    .bold()
                    .padding(.horizontal)
                    .font(.title2)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity , alignment: .leading)
                HStack{
                    Text("Number of Hard Questions")
                        .bold()
                        .padding(.horizontal)
                        .font(.title3)
                        .foregroundColor(Color.orange)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("H" , text: $hard)
                        .padding()
                        .frame(width: 50, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
                VStack{
                    Text("Total Questions")
                        .bold()
                        .padding(.horizontal)
                        .font(.title3)
                        .foregroundColor(Color.green)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("Total" , text: $totalQuestions)
                        .padding()
                        .frame(width: 250, height: 40)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    Button("Save"){
                        createDifficulty()
                        showAlert
                    }
                    .bold()
                    .padding()
                    .frame(width: 150)
                    .foregroundColor(.black)
                    .background(Color.teal)
                    .cornerRadius(8)
//                    Spacer()
                }
            }
            Spacer()
        }
        .navigationBarItems(leading: backButton)
        .background(Image("fc").resizable().ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Congratulations"), message: Text("Questions Difficulty Updated Successfully"), dismissButton: .default(Text("OK")))
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
    func createDifficulty() {
        guard let url = URL(string: "http://localhost:2000/adddifficulty") else {
            return
        }

        let user = [
            "easy": easy,
            "medium": medium,
            "hard": hard,
            "totalquestions": totalQuestions
        ] as [String : Any]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: user) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data)
                    print("Result from server:", result)
                    showAlert = true
                    DispatchQueue.main.async {
                        easy = ""
                        medium = ""
                        hard = ""
                        totalQuestions = ""
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }
}

struct Difficulty_Previews: PreviewProvider {
    static var previews: some View {
        Difficulty()
    }
}
