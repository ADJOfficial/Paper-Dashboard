////
////  HODRecords.swift
////  Director Dashboard
////
////  Created by ADJ on 12/03/2024.
////
//
import Foundation

struct ACTF: Codable  ,Hashable {
    let f_id: Int
    let c_id: Int
    let c_code: String
    let c_title: String
    let f_name: String
    
}

class AssignedCoursesViewModel: ObservableObject {
    
    @Published var assignedCourses: [ACTF] = []
    
//    func fetchAssignedCourses(facultyID: Int) {
//        guard let url = URL(string: "http://localhost:2000/FacultyAssignedCourse?f_id=\(facultyID)") else {
//            print("Invalid URL")
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
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
//                let decodedData = try JSONDecoder().decode([ACTF].self, from: data)
//                DispatchQueue.main.async {
//                    self.assignedCourses = decodedData
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
    func fetchAssignedCourses(facultyID: Int) {
        guard let url = URL(string: "http://localhost:2000/FacultyAssignedCourse?f_id=\(facultyID)") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 404 {
                    print("No assigned courses found for faculty ID: \(facultyID)")
                    return
                }
            }

            do {
                let decoder = JSONDecoder()
                let courses = try decoder.decode([ACTF].self, from: data)
                
                DispatchQueue.main.async {
                    self.assignedCourses = courses
                    print("Fetched \(courses.count) assigned courses for faculty ID: \(facultyID)")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func isCourseAssigned(courseID: Int) -> Bool {
        return assignedCourses.contains { $0.c_id == courseID }
        print("Checking if course \(courseID) is assigned")
    }
    
    func deleteAssignedCourse(facultyId: Int, courseId: Int) {
        // Perform the deletion using an API call or database query
        deleteAssignedCourseFromServer(facultyId: facultyId, courseId: courseId) { success in
            if success {
                // Remove the deleted assigned course from the array
                DispatchQueue.main.async {
                    if let index = self.assignedCourses.firstIndex(where: { $0.f_id == facultyId && $0.c_id == courseId }) {
                        self.assignedCourses.remove(at: index)
                    }
                }
            } else {
                // Handle error
                print("Failed to delete assigned course")
            }
        }
    }

    private func deleteAssignedCourseFromServer(facultyId: Int, courseId: Int, completion: @escaping (Bool) -> Void) {
        // Make the API call or database query to delete the assigned course
        // You can use URLSession or Alamofire to make the HTTP request
        
        // Example using URLSession
        guard let url = URL(string: "http://localhost:2000/DeleteAssignedCourse/\(facultyId)/\(courseId)") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting assigned course:", error)
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}

struct Courer: Codable  ,Hashable {
    let f_id: Int
    let c_id: Int
    let c_code: String
    let c_title: String
    let f_name: String
    var role: String
    
}

class CoViewModel: ObservableObject {
    @Published var Courseassignedto: [Courer] = []
    
    func fetchCoursesAssignedTo(courseID: Int)  {
        guard let url = URL(string: "http://localhost:2000/CourseAssignedTo?c_id=\(courseID)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                            print("Response status code: \(httpResponse.statusCode)")
                        }
            
            do {
                let courses = try JSONDecoder().decode([Courer].self, from: data)
                DispatchQueue.main.async {
                    self.Courseassignedto = courses
                    print("Fetched \(courses.count) assigned faculty for Course : \(courseID)")
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    func deleteAssignedCourse(courseId: Int , facultyId: Int) {
        // Perform the deletion using an API call or database query
        deleteAssignedCourseFromServer(courseId: courseId , facultyId: facultyId) { success in
            if success {
                // Remove the deleted assigned course from the array
                DispatchQueue.main.async {
                    if let index = self.Courseassignedto.firstIndex(where: { $0.c_id == courseId && $0.f_id == facultyId }) {
                        self.Courseassignedto.remove(at: index)
                    }
                }
            } else {
                // Handle error
                print("Failed to delete assigned course")
            }
        }
    }

    private func deleteAssignedCourseFromServer(courseId: Int , facultyId: Int, completion: @escaping (Bool) -> Void) {
        // Make the API call or database query to delete the assigned course
        // You can use URLSession or Alamofire to make the HTTP request
        
        // Example using URLSession
        guard let url = URL(string: "http://localhost:2000/DeleteAssignedFaculty/\(courseId)/\(facultyId)") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting assigned course:", error)
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
