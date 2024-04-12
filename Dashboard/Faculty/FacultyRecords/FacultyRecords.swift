//////
//////  FacultyRecords.swift
//////  Director Dashboard
//////
//////  Created by ADJ on 13/03/2024.
//////
////
import Foundation

//struct feedback: Hashable , Decodable  ,Encodable {
//
//        var fb_details: String
//}
//
//class FeedBackViewModel: ObservableObject {
//
//    @Published var fb: [feedback] = []
//    //    @Published var f_id: [Int] = [] // To get ID
//
//    func fetchExistingFeedback() {
//        guard let url = URL(string: "http://localhost:4000/getfeedback")
//
//        else{
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//
//            guard let data = data , error == nil
//
//            else {
//                return
//            }
//
//            // Convert to JSON
//
//            do{
//                let fbs = try JSONDecoder().decode([feedback].self, from: data)
//                DispatchQueue.main.async {
//                    self?.fb = fbs
//                    print("Fetched \(fbs.count) Faculties")
//                }
//            }
//            catch{
//                print("Error While Getting Data")
//            }
//        }
//        task.resume()
//    }
////    func markAsRead(_ feedback: feedback) {
////        if let index = fb.firstIndex(of: feedback) {
////            fb[index].isRead = true
////        }
////    }
//}


struct Feedback: Hashable, Decodable, Encodable {
    var fb_details: String
    var f_id: Int
    var c_id: Int
    var c_title: String
    var c_code: String
    var f_name: String
    var q_id: Int
    var p_id: Int
}

class FeedbackViewModel: ObservableObject {
    @Published var feedback: [Feedback] = []
    
    func fetchExistingFeedback(facultyID: Int, courseID: Int) {
        guard let url = URL(string: "http://localhost:4000/getfeedback?facultyID=\(facultyID)&courseID=\(courseID)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let feedback = try JSONDecoder().decode([Feedback].self, from: data)
                DispatchQueue.main.async {
                    self?.feedback = feedback
                    print("Fetched \(feedback.count) feedbacks")
                }
            } catch {
                print("Error while getting data: \(error)")
            }
        }
        
        task.resume()
    }
}

//struct Topic: Hashable , Decodable  ,Encodable {
//
//    var t_id: Int
//    var t_name: String
//    var status: String
//}
//
//class TopicViewModel: ObservableObject {
//
//    @Published var existing: [Topic] = []
//
//    func getCourseTopic(courseID: Int) {
//        guard let url = URL(string: "http://localhost:4000/getcoursetopics/\(courseID)") else {
//            print("Invalid URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let questions = try decoder.decode([Topic].self, from: data)
//                DispatchQueue.main.async {
//                    self.existing = questions
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        }
//        .resume()
//    }
//}
//
//struct SubTopic: Hashable , Decodable  ,Encodable {
//
//    var st_id: Int
//    var st_name: String
//    var status: String
//}
//
//class SubTopicViewModel: ObservableObject {
//
//    @Published var existing: [SubTopic] = []
//
//    func getTopicSubTopic(topicID: Int) {
//        guard let url = URL(string: "http://localhost:4000/getsubtopic/\(topicID)") else {
//            print("Invalid URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let questions = try decoder.decode([SubTopic].self, from: data)
//                DispatchQueue.main.async {
//                    self.existing = questions
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        }
//        .resume()
//    }
//}

struct CoveredTopic: Hashable , Decodable  ,Encodable {
    
    var f_id: Int
    var c_id: Int
    var t_id: Int
    var st_id: Int
    
}

class CoveredTopicViewModel: ObservableObject {

    @Published var existing: [CoveredTopic] = []

    func getTopicSubTopic(facultyID: Int) {
        guard let url = URL(string: "http://localhost:4000/coveredtopics/\(facultyID)") else {
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
                let questions = try decoder.decode([CoveredTopic].self, from: data)
                DispatchQueue.main.async {
                    self.existing = questions
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }
}


struct CLO: Hashable , Decodable  ,Encodable {

    var clo_id: Int
    var clo_code: String
    var clo_text: String
    var status: String
    var enabledisable: String
    
}

class CLOViewModel: ObservableObject {

    @Published var existing: [CLO] = []

    func getCourseCLO(courseID: Int) {
        guard let url = URL(string: "http://localhost:4000/getclo/\(courseID)") else {
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
                let questions = try decoder.decode([CLO].self, from: data)
                DispatchQueue.main.async {
                    self.existing = questions
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }
}
