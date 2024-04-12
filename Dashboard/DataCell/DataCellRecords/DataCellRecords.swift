//
//  FacultyRecords.swift
//  Director Dashboard
//
//  Created by ADJ on 07/03/2024.

import Foundation

// To Get All Existing Faculties Members

struct faculties: Hashable , Decodable  ,Encodable {
        
        var f_id: Int // To detect ID of That date to be get/edit
//        var c_id: Int?
        var f_name: String
        var username: String
        var password: String
        var status: String
//        var c_id: Int
}

class FacultiesViewModel: ObservableObject {
    
    @Published var remaining: [faculties] = []
    @Published var f_id: [Int] = [] // To get ID
    
    func fetchExistingFaculties() {
        guard let url = URL(string: "http://localhost:8000/showexistingfaculties")
                
        else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let data = data , error == nil
                    
            else {
                return
            }
            
            // Convert to JSON
            
            do{
                let faculty = try JSONDecoder().decode([faculties].self, from: data)
                DispatchQueue.main.async {
                    self?.remaining = faculty
                    print("Fetched \(faculty.count) Faculties")
                }
            }
            catch{
                print("Error While Getting Data")
            }
        }
        task.resume()
    }
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
            let url = URL(string: "http://localhost:8000/LoginAllMembers")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let parameters: [String: Any] = [
                "username": username,
                "password": password
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                    return
                }
                
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = responseJSON["message"] as? String {
                    // Login successful
                    completion(true)
                    print(message)
                } else {
                    // Invalid credentials
                    completion(false)
//                    showAlert = true
                }
            }.resume()
        }
}


// To Get All Existing Faculties Members


struct AllCourses: Hashable , Decodable  ,Encodable {

        var c_id: Int // To detect ID of That date to be get/edit
        var c_code: String
        var c_title: String
        var cr_hours: Int
        var status: String
//    var approved
}

class CoursesViewModel: ObservableObject {

    @Published var existing: [AllCourses] = []

    func fetchExistingCourses() {
        guard let url = URL(string: "http://localhost:8000/showexistingcourse") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let courses = try JSONDecoder().decode([AllCourses].self, from: data)
                DispatchQueue.main.async {
                    self?.existing = courses
                    print("Fetched \(courses.count) courses")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}


// To Get All Existing Papers


struct Paper: Hashable, Codable {
    var p_id: Int
    var p_name: String
    var status: String
    // Add any other properties you need
}

class PaperViewModel: ObservableObject {
    
    @Published var existingPapers: [Paper] = []
    
    func fetchApprovedPapers() { // it fetches all Papers where Status = "Approved"
        
        guard let url = URL(string: "http://localhost:8000/getapprovedpapers") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let papers = try JSONDecoder().decode([Paper].self, from: data)
                DispatchQueue.main.async {
                    self?.existingPapers = papers
                    print("Fetched \(papers.count) papers")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    func fetchPrintedPapers() { // it fetches Only Printed Papers
        
        guard let url = URL(string: "http://localhost:8000/showprintedpapers") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let papers = try JSONDecoder().decode([Paper].self, from: data)
                DispatchQueue.main.async {
                    self?.existingPapers = papers
                    print("Fetched \(papers.count) papers")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    func fetchExistingPapers() { // it fetches Only All Papers P_name and Their Status
        
        guard let url = URL(string: "http://localhost:8000/getexistingpapers") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let papers = try JSONDecoder().decode([Paper].self, from: data)
                DispatchQueue.main.async {
                    self?.existingPapers = papers
                    print("Fetched \(papers.count) papers")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func fetchFacultyPaper(facultyID: Int) {
        guard let url = URL(string: "http://localhost:4000/getfacultypaper/\(facultyID)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let papers = try decoder.decode([Paper].self, from: data)
                DispatchQueue.main.async {
                    self.existingPapers = papers
                    print("Fetched \(papers.count) papers")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }
}


