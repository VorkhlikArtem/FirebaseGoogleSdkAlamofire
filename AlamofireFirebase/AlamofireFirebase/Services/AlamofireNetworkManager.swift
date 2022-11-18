//
//  AlamofireNetworkManager.swift
//  AlamofireFirebase
//
//  Created by Артём on 13.11.2022.
//

import Foundation
import Alamofire


class AlamofireNetworkManager {
    
   static var onProgress: ((Double)->Void)?
    static var completed: ((String)->Void)?
    
    static func fetchData(url: String, completion: @escaping ([Course])->()) {
        guard let url = URL(string: url) else {return}
        
        AF.request(url).validate().response { response in
            switch response.result {
            case .success(let value):
                guard let value = value else {return}
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let courses = try decoder.decode([Course].self, from: value)
                    completion(courses)
                } catch let error {
                    print("Error serialization json", error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else {return}
        
        AF.request(url).validate().responseData { response in
            switch response.result {
                
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func downloadImageWithProgress(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: url) else {return}
        
        AF.request(url).validate().downloadProgress { progress in
            print("totalUnitCount: \(progress.totalUnitCount)\n")
            print("completedUnitCount:\(progress.completedUnitCount)\n")
            print("fractionCompleted:\(progress.fractionCompleted)\n")
            print("loclizedDescription:\(progress.localizedDescription!)\n")
            print("---------------------------------------------------------")
            
            self.completed?(progress.localizedDescription)
            self.onProgress?(progress.fractionCompleted)
            
        }.response { response in
            guard let data = response.data,
                  let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    static func postRequest(url: String, completion: @escaping ([Course])->()){
        guard let url = URL(string: url) else {return}
        
        let userData: [String: Any] = ["name": "POST Network Request",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "numberOfLessons": 18,
                                       "numberOfTests": 10]
        
        AF.request(url, method: .post, parameters: userData).response { response in
            guard let statusCode = response.response?.statusCode else {return}
            print(statusCode)
            
            switch response.result {
                
            case .success(let data):
                guard let data = data else {return}
                let course = try? JSONSerialization.jsonObject(with: data, options: [])
                print(course as Any)
                guard
                    let jsonObject = course as? [String: Any],
                    let course = Course(json: jsonObject)
                    else { return }

                var courses = [Course]()
                courses.append(course)
                completion(courses)
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func putRequest(url: String, completion: @escaping ([Course])->()){
        guard let url = URL(string: url) else {return}
        
        let userData: [String: Any] = ["name": "PUT Network Request",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "numberOfLessons": 18,
                                       "numberOfTests": 10]
        
        AF.request(url, method: .put, parameters: userData).response { response in
            guard let statusCode = response.response?.statusCode else {return}
            print(statusCode)
            
            switch response.result {
                
            case .success(let data):
                guard let data = data else {return}
                let course = try? JSONSerialization.jsonObject(with: data, options: [])
                print(course as Any)
                guard
                    let jsonObject = course as? [String: Any],
                    let course = Course(json: jsonObject)
                    else { return }

                var courses = [Course]()
                courses.append(course)
                completion(courses)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
         
     
}
