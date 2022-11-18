//
//  CoursesViewController.swift
//  AlamofireFirebase
//
//  Created by Артём on 12.11.2022.
//

import UIKit

class CoursesViewController: UIViewController {
    
    private let url = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let postRequestUrl = "https://jsonplaceholder.typicode.com/posts"
    private let putRequestUrl = "https://jsonplaceholder.typicode.com/posts/1"
    private var courses = [Course]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        fetchData()
    }
    
    func fetchData() {
        NetworkManager.fetchData(url: url) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkManager.fetchData(url: url) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func postWithAlamofire() {
        AlamofireNetworkManager.postRequest(url: postRequestUrl) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func putWithAlamofire() {
        AlamofireNetworkManager.putRequest(url: putRequestUrl) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
}

extension CoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.configure(with: courses[indexPath.row])
        return cell
    }
    
    
}

extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        
        let courseURL = course.link
        let courseName = course.name
        
        guard let webVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WebViewController.identifier) as? WebViewController else {return}
        
        webVC.selectedCourse = courseName
        if let url = courseURL {
            webVC.courseURL = url
        }
        navigationController?.pushViewController(webVC, animated: true)
    }
}
