//
//  Session.swift
//  Dashboard
//
//  Created by ADJ on 02/06/2024.
//

import SwiftUI

struct Session: View { // Design 100% Ok
    
    @State private var sessionName = ""
    @State private var sessionYear = ""
    @State private var searchText = ""
    @StateObject private var sessionViewModel = SessionViewModel()
    @StateObject private var activeSessionViewModel = ActiveSessionViewModel()
    
    @State private var showAlert = false
    
    var filteredSession: [ManageSession] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return sessionViewModel.session
        } else {
            return sessionViewModel.session.filter { session in
                session.s_name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func getStatusColor(status: String) -> Color {
        switch status {
        case "Rejected":
            return .red
        case "Approved":
            return .green
        case "Pending":
            return .yellow
        default:
            return .white
        }
    }
    
    var body: some View { // Get All Data From Node MongoDB : Pending
        
        NavigationView {
            VStack {
                Text("Manage Session")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                HStack{
                    Text(activeSessionViewModel.activeSessionName)
                        .font(.title2)
                        .foregroundColor(Color.green)
                    Text(activeSessionViewModel.activeSessionYear)
                        .font(.title2)
                        .foregroundColor(Color.yellow)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity , alignment: .trailing)
                .onAppear {
                    activeSessionViewModel.getActiveSession()
                }
                VStack {
                    Text("Session Name")
                        .padding(.horizontal)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("Enter Session Name" , text: $sessionName)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    Text("Session Year")
                        .padding(.horizontal)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("Enter Session Year" , text: $sessionYear)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Button("Add"){
                        createCLO()
                        showAlert
                    }
                    .bold()
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.teal)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .trailing)
                }
                Spacer()
                VStack {
                    ScrollView{
                        ForEach(filteredSession.indices , id:\ .self) { index in
                            let cr = filteredSession[index]
                            HStack{
                                Text(cr.s_name)
                                    .bold()
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                Text("\(String(cr.s_year))")
                                    .bold()
                                    .font(.title3)
                                    .foregroundColor(Color.white)
                                    .frame(maxWidth: .infinity , alignment: .leading)
                                NavigationLink{
                                    EditSession(s_name: sessionName, s_year: Int(sessionYear) ?? 0, session: cr)
                                        .navigationBarBackButtonHidden(true)
                                }label: {
                                    Image(systemName: "square.and.pencil.circle")
                                        .font(.title)
                                        .foregroundColor(Color.orange)
                                        .frame(alignment: .trailing)
                                }
                                Image(systemName: isSessionEnabled(index) ? "checkmark.circle.fill" : "nosign")
                                    .font(.title)
                                    .foregroundColor(isSessionEnabled(index) ? .green : .red)
                                    .onTapGesture {
                                        toggleSessionStatus(index)
                                    }
                            }
                            Divider()
                                .background(Color.white)
                                .padding(1)
                        }
                    }
                    if filteredSession.isEmpty {
                        Text("No Session Found")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                )
                .frame(height:300)
                .onAppear {
                    sessionViewModel.fetchExistingSession()
                }
            }
            .navigationBarItems(leading: backButton)
            .background(Image("fc").resizable().ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Congratulations"), message: Text("Session Created Successfully"), dismissButton: .default(Text("OK")))
            }
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
    func createCLO() {
        guard let url = URL(string: "http://localhost:2000/addsession") else {
            return
        }

        let user = [
            "s_name": sessionName,
            "s_year": sessionYear
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
                    sessionViewModel.fetchExistingSession() // Refresh faculties after creating a new one
                    showAlert = true
                    DispatchQueue.main.async {
                        sessionName = ""
                        sessionYear = ""
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }
    
    func isSessionEnabled(_ index: Int) -> Bool {
        return filteredSession[index].status == 1
    }
    func toggleSessionStatus(_ index: Int) {
        let topic = filteredSession[index]

        guard let url = URL(string: "http://localhost:2000/editstatus/\(topic.s_id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["status": true] // Set the status to true to update the current session
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating Session status: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                print("Session status updated successfully")
                sessionViewModel.fetchExistingSession()
            } else {
                print("Failed to update Session status")
            }
        }.resume()
    }
}

struct EditSession: View { // Design 100% Ok

    var s_name: String
    var s_year: Int

    var session: ManageSession

    @State private var sessionName = ""
    @State private var sessionYear = ""
    @State private var searchText = ""

    @StateObject private var sessionViewModel = SessionViewModel()

    @State private var showAlert = false

    var filteredSession: [ManageSession] { // All Data Will Be Filter and show on Table
        if searchText.isEmpty {
            return sessionViewModel.session
        } else {
            return sessionViewModel.session.filter { session in
                session.s_name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View { // Get All Data From Node MongoDB : Pending

        NavigationView {
            VStack {
                Text("Edit Session")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Spacer()
                VStack {
                    Text("Session Name")
                        .padding(.horizontal)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("Enter Session Name" , text: $sessionName)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onAppear{
                            sessionName = session.s_name
                        }
                    Text("Session Year")
                        .padding(.horizontal)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity , alignment: .leading)
                    TextField("Enter Session Year" , text: $sessionYear)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.gray.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onAppear{
                            sessionYear = String(session.s_year)
                        }
                    Button("Update"){
                        updateSession()
                        showAlert
                    }
                    .bold()
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.teal)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity , alignment: .trailing)
                }
                Spacer()
                .onAppear {
                    sessionViewModel.fetchExistingSession()
                }
            }
            .background(Image("fc").resizable().ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Congratulations"), message: Text("Session Updated Successfully"), dismissButton: .default(Text("OK")))
            }
            .navigationBarItems(leading: backButton)
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
    func updateSession() {
        guard let url = URL(string: "http://localhost:2000/updatesession/\(session.s_id)") else {
            return
        }

        let updatedSession = ManageSession(s_id: session.s_id, s_name: sessionName, s_year: sessionYear , status: session.status)

        guard let encodedData = try? JSONEncoder().encode(updatedSession) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error while updating session: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")

            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let message = responseJSON?["message"] as? String, message == "Session record updated successfully" {
                    print("Session updated successfully")
                    showAlert = true
                } else if let error = responseJSON?["error"] as? String {
                    print("Error updating session: \(error)")
                }
            } catch {
                print("Error while decoding response data: \(error)")
            }
        }
        task.resume()
    }
}

struct Session_Previews: PreviewProvider {
    static var previews: some View {
        Session()
    }
}
