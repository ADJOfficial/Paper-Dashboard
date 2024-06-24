//////
//////  FacultyRecords.swift
//////  Director Dashboard
//////
//////  Created by ADJ on 13/03/2024.
//////
////
import Foundation

//import Foundation
//
//class EditQuestionViewModel: ObservableObject {
//    @Published var question: GetPaperQuestions
//    @Published var options: [String]
//    @Published var topics: [Topic]
//    @Published var selectedDifficulty: Int
//    @Published var selectedTopic: Int?
//    
//    init(question: GetPaperQuestions, options: [String], topics: [Topic]) {
//        self.question = question
//        self.options = options
//        self.topics = topics
//        self.selectedDifficulty = options.firstIndex(of: question.q_difficulty) ?? 0
//        self.selectedTopic = topics.first { $0.t_id == question.t_id }?.t_id
//    }
//    
//    func saveChanges() {
//        // Add logic to save changes to the database or backend
//    }
//}



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
    var q_verification: String
    var status: String
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

struct Topic: Hashable , Decodable  ,Encodable {

    var t_id: Int
    var t_name: String
    var status: String
}

class TopicViewModel: ObservableObject {

    @Published var existing: [Topic] = []

    func getCourseTopic(courseID: Int) {
        guard let url = URL(string: "http://localhost:4000/getcoursetopics/\(courseID)") else {
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
                let questions = try decoder.decode([Topic].self, from: data)
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

struct SubTopic: Hashable , Decodable  ,Encodable {
    
    var t_id: Int
    var st_id: Int
    var st_name: String
    var status: String
    
}

class SubTopicViewModel: ObservableObject {

    @Published var existing: [SubTopic] = []

    func getTopicSubTopic(topicID: Int) {
        guard let url = URL(string: "http://localhost:4000/getsubtopic/\(topicID)") else {
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
                let subTopic = try decoder.decode([SubTopic].self, from: data)
                DispatchQueue.main.async {
                    self.existing = subTopic
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }
}

//struct TopicTaught: Hashable , Decodable  ,Encodable {
//
//    var f_id: Int
//    var t_id: Int
//    var st_id: Int
//}
//
//class TopicTaughtViewModel: ObservableObject {
//
//    @Published var taught: [TopicTaught] = []
//
//    func getTopicTaught(courseID: Int) {
//        guard let url = URL(string: "http://localhost:4000/coveredtopics/\(courseID)") else {
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
//                let subTopic = try decoder.decode([TopicTaught].self, from: data)
//                DispatchQueue.main.async {
//                    self.taught = subTopic
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        }
//        .resume()
//    }
//}

struct TopicTaught: Hashable, Decodable, Encodable {
    var f_id: Int
    var t_id: Int
    var st_id: Int
    var f_name: String
    var faculty_count: Int
}

class TopicTaughtViewModel: ObservableObject {
    @Published var taught: [TopicTaught] = []
    @Published var commonTopics: [Int: [Int]] = [:]
    @Published var facultyNames: [Int: [String]] = [:]

    func getTopicTaught(courseID: Int, facultyID: Int) {
        guard let url = URL(string: "http://localhost:4000/coveredtopics/\(courseID)/\(facultyID)") else {
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
                let topics = try decoder.decode([TopicTaught].self, from: data)
                DispatchQueue.main.async {
                    self.taught = topics
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }

    func getAllTopicTaught(courseID: Int) {
        guard let url = URL(string: "http://localhost:4000/coveredtopics/\(courseID)") else {
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
                let topics = try decoder.decode([TopicTaught].self, from: data)
                DispatchQueue.main.async {
                    self.commonTopics = self.findCommonTopics(topics: topics)
                    self.facultyNames = self.getFacultyNames(topics: topics)
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }

    private func findCommonTopics(topics: [TopicTaught]) -> [Int: [Int]] {
        var common: [Int: [Int]] = [:]
        for topic in topics {
            if topic.faculty_count > 1 {
                if common[topic.t_id] == nil {
                    common[topic.t_id] = []
                }
                common[topic.t_id]?.append(topic.st_id)
            }
        }
        return common
    }

    private func getFacultyNames(topics: [TopicTaught]) -> [Int: [String]] {
        var names: [Int: [String]] = [:]
        for topic in topics {
            if names[topic.t_id] == nil {
                names[topic.t_id] = []
            }
            if !names[topic.t_id]!.contains(topic.f_name) {
                names[topic.t_id]!.append(topic.f_name)
            }
        }
        return names
    }

    func getCommonFacultyNames(for topicID: Int) -> [String] {
        return facultyNames[topicID] ?? []
    }
}

//    private func findCommonTopics(topics: [TopicTaught]) -> [Int: [Int]] {
//        var common: [Int: [Int]] = [:]
//        for topic in topics {
//            if topic.faculty_count > 1 {
//                if common[topic.t_id] == nil {
//                    common[topic.t_id] = []
//                }
//                common[topic.t_id]?.append(topic.st_id)
//            }
//        }
//        return common
//    }
//
//    private func getFacultyNames(topics: [TopicTaught]) -> [String] {
//        var names: [String] = []
//        for topic in topics {
//            if !names.contains(topic.f_name) {
//                names.append(topic.f_name)
//            }
//        }
//        return names
//    }
//
//    func getCommonFacultyNames(for topicID: Int) -> [String] {
//        guard let commonSubtopicIDs = commonTopics[topicID] else {
//            return []
//        }
//
//        var commonFacultyNames: [String] = []
//        for subtopicID in commonSubtopicIDs {
//            let subtopicTaught = taught.filter { $0.t_id == topicID && $0.st_id == subtopicID }
//            for teach in subtopicTaught {
//                if !commonFacultyNames.contains(teach.f_name) {
//                    commonFacultyNames.append(teach.f_name)
//                }
//            }
//        }
//        return commonFacultyNames
//    }



//class TopicTaughtViewModel: ObservableObject {
//    @Published var taught: [TopicTaught] = []
//    @Published var commonTopics: [Int: [Int]] = [:]
//
//    func getTopicTaught(courseID: Int) {
//        guard let url = URL(string: "http://localhost:4000/coveredtopics/\(courseID)") else {
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
//                let topics = try decoder.decode([TopicTaught].self, from: data)
//                DispatchQueue.main.async {
//                    self.taught = topics
//                    self.commonTopics = self.findCommonTopics(topics: topics)
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        }
//        .resume()
//    }
//
//    private func findCommonTopics(topics: [TopicTaught]) -> [Int: [Int]] {
//        var common: [Int: [Int]] = [:]
//        for topic in topics {
//            if topic.faculty_count > 1 {
//                if common[topic.t_id] == nil {
//                    common[topic.t_id] = []
//                }
//                common[topic.t_id]?.append(topic.st_id)
//            }
//        }
//        return common
//    }
//}

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
struct TopicCLO: Hashable , Decodable  ,Encodable {

    var clo_id: Int
    var clo_code: String
    
}

class TopicCLOViewModel: ObservableObject {

    @Published var topicCLO: [TopicCLO] = []

    func getTopicCLO(topicID: Int) {
        guard let url = URL(string: "http://localhost:4000/gettopicclo/\(topicID)") else {
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
                let topicclo = try decoder.decode([TopicCLO].self, from: data)
                DispatchQueue.main.async {
                    self.topicCLO = topicclo
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        .resume()
    }
}


struct CourseCLOGridViewWeightage: Hashable , Decodable  ,Encodable {
   
    var gvw_id: Int
    var clo_id: Int
    var clo_code: String
    var weightage1: Int
    var weightage2: Int
    var weightage3: Int
    var weightage4: Int
    
}
class CourseCLOGridViewWeightageViewModel: ObservableObject {
    
    @Published var CourseCLOgvh: [CourseCLOGridViewWeightage] = []
    
    func fetchExistingGridWeightage(courseID: Int) {
        guard let url = URL(string: "http://localhost:4000/getcourseclogvw/\(courseID)") else {
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
                let grid = try JSONDecoder().decode([CourseCLOGridViewWeightage].self, from: data)
                DispatchQueue.main.async {
                    self?.CourseCLOgvh = grid
                    print("Fetched \(grid.count) Headers")
                }
            } catch {
                print("Error decoding !!!!data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}


struct QDifficulty: Hashable, Decodable, Encodable {
    var totalquestions: Int
    var easy: Int
    var medium: Int
    var hard: Int
}

class DifficultyViewModel: ObservableObject {
    @Published var questionD: [QDifficulty] = []
    
    func fetchExistingDifficulty(question: Int) {
        guard let url = URL(string: "http://localhost:4000/getdifficulty/\(question)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let feedback = try JSONDecoder().decode([QDifficulty].self, from: data)
                DispatchQueue.main.async {
                    self?.questionD = feedback
                    print("Fetched \(feedback.count) Difficulties")
                }
            } catch {
                print("Error while getting data: \(error)")
            }
        }
        
        task.resume()
    }
}

struct CourseSenior: Hashable, Decodable, Encodable {
    
    var f_id: Int
    var f_name: String

}

class CourseSeniorViewModel: ObservableObject {
    
    @Published var senior: [CourseSenior] = []
    
    func fetchExistingSenior(course: Int) {
        guard let url = URL(string: "http://localhost:2000/getfname/\(course)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let feedback = try JSONDecoder().decode([CourseSenior].self, from: data)
                DispatchQueue.main.async {
                    self?.senior = feedback
                    print("Fetched \(feedback.count) Senior")
                }
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
            } catch let error {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

struct PaperHeader: Hashable, Decodable, Encodable {
    
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
    var f_id: Int
    var c_id: Int

}

class PaperHeaderViewModel: ObservableObject {
    
    @Published var header: [PaperHeader] = []
    
    func fetchExistingHeader(course: Int) {
        guard let url = URL(string: "http://localhost:4000/getpaperheader/\(course)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let feedback = try JSONDecoder().decode([PaperHeader].self, from: data)
                DispatchQueue.main.async {
                    self?.header = feedback
                    print("Fetched \(feedback.count) Heahers")
                }
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
            } catch let error {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
