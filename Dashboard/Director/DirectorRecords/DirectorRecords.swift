//
//  MySQL-Director.swift
//  Director Dashboard
//
//  Created by ADJ on 16/03/2024.
//

import Foundation

struct GetUploadedPaper: Hashable , Decodable  ,Encodable {
        // To detect ID of That date to be get/edit
    var p_id: Int
    var p_name: String
    var duration: Int
    var degree: String
    var t_marks: Int
    var term: String
    var year: Int
    var exam_date: String
    var semester: String
    var status: String
    var t_questions: Int
    var c_id: Int
    var c_title: String
    var c_code: String
    var f_id: Int
    var f_name: String
//    var q_id: Int
//    var t_id: Int
//    var clo_text: String
//    var t_name: String
    
}

class UploadedPaperViewModel: ObservableObject {
    
    @Published var uploaded: [GetUploadedPaper] = []
    //    @Published var c_id: [Int] = [] // To get ID
    
    func fetchUploadedPapers() {
        guard let url = URL(string: "http://localhost:3000/getuploadedpapers")
                
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
                let faculty = try JSONDecoder().decode([GetUploadedPaper].self, from: data)
                DispatchQueue.main.async {
                    self?.uploaded = faculty
                    print("Fetched \(faculty.count) Faculties")
                }
            }
            catch{
                print("Error While Getting Data", error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func fetchApprovedPapers() {
        guard let url = URL(string: "http://localhost:3000/getapprovedpapers")
                
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
                let faculty = try JSONDecoder().decode([GetUploadedPaper].self, from: data)
                DispatchQueue.main.async {
                    self?.uploaded = faculty
                    print("Fetched \(faculty.count) Faculties")
                }
            }
            catch{
                print("Error While Getting Data", error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func fetchPaperStatus(paperId: Int, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/getpaperstatus?p_id=\(paperId)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let status = result?["status"] as? String {
                    completion(status)
                } else if let error = result?["error"] as? String {
                    print("Error: \(error)")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}


struct GetPaperQuestions: Hashable, Decodable, Encodable {
    var q_id: Int
    var q_text: String
    var q_image: String?
    var q_marks: Int
    var q_difficulty: String
    var q_verification: String
    var p_id: Int
    var c_id: Int
    var c_code: String
    var c_title: String
    var f_id: Int
    var f_name: String
    var clo_code: String
    var clo_text: String
    var t_name: String
}

class QuestionViewModel: ObservableObject {
    
    @Published var uploadedQuestions: [GetPaperQuestions] = []
    @Published var selectedQuestionIndex: Int?
    
    func getPaperQuestions(paperID: Int) {
        guard let url = URL(string: "http://localhost:3000/getpaperquestion/\(paperID)") else {
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
//                decoder.dataDecodingStrategy = .base64
                let questions = try decoder.decode([GetPaperQuestions].self, from: data)
                DispatchQueue.main.async {
                    self.uploadedQuestions = questions
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }
    
    func getPaperAdditionalQuestions(paperID: Int) {
        guard let url = URL(string: "http://localhost:3000/getpaperadditionalquestion/\(paperID)") else {
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
                //                decoder.dataDecodingStrategy = .base64
                let questions = try decoder.decode([GetPaperQuestions].self, from: data)
                DispatchQueue.main.async {
                    self.uploadedQuestions = questions
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }
    
    func sendSelectedQuestionBack(selectedQuestionIndex: Int) {
            self.selectedQuestionIndex = selectedQuestionIndex
        }
}
    

