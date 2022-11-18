//
//  MainCollectionViewController.swift
//  AlamofireFirebase
//
//  Created by Артём on 12.11.2022.
//

import UIKit
import UserNotifications
import Alamofire
import FirebaseAuth

private let reuseIdentifier = "Cell"

enum Actions: String, CaseIterable {
    
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case myCourses = "My Courses"
    case downloadFile = "Download File"
    case myCoursesAlamofire = "My Courses (Alamofire)"
    case responseData = "responseData"
    case downloadLargeImage = "Download Large Image"
    case postAlamofire = "POST with Alamofire"
    case putRequest = "PUT Request with Alamofire"

}

class MainCollectionViewController: UICollectionViewController {
    
    private let actions = Actions.allCases
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    private var filePath: String?
    
    
    let urlString = "https://jsonplaceholder.typicode.com/posts"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotification()
        
        dataProvider.fileLocation = { (location) in
            
            // Сохранить файл для дальнейшего использования
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }
        
        checkLogIn()
        
        

    }
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        alert.view.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dataProvider.stopDownload()
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true) {
            
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2,
                                y: self.alert.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0,
                                                            y: self.alert.view.frame.height - 44,
                                                            width: self.alert.view.frame.width,
                                                            height: 2))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress = { (progress) in
                
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCVCell
        cell.label.text = actions[indexPath.row].rawValue
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
            
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: nil)
        case .get:
            NetworkManager.getRequest(url: urlString)
        case .post:
            NetworkManager.postRequest(url: urlString)
        case .myCourses:
            performSegue(withIdentifier: "OurCourses", sender: nil)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
            
            // Alamofire
        case .myCoursesAlamofire:
            performSegue(withIdentifier: "OurCoursesAlamofire", sender: nil)
        case .responseData:
            performSegue(withIdentifier: "ShowImageWithAlamofire", sender: nil)
        case .downloadLargeImage:
            performSegue(withIdentifier: "DownloadWithAlamofire", sender: nil)
        case .postAlamofire:
            performSegue(withIdentifier: "PostAlamofire", sender: nil)
        case .putRequest:
            performSegue(withIdentifier: "PutAlamofire", sender: nil)


        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CoursesViewController
        let imageVC = segue.destination as? ImageViewController
        
        
        switch segue.identifier {
        case "OurCourses":
            coursesVC?.fetchData()
        case "OurCoursesAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "ShowImage":
            imageVC?.fetchImage()
        case "ShowImageWithAlamofire":
            imageVC?.fetchDataWithAlamofire()
        case "DownloadWithAlamofire":
            imageVC?.downloadLargeImageWithAlamofire()
        case "PostAlamofire":
            coursesVC?.postWithAlamofire()
        case "PutAlamofire":
            coursesVC?.putWithAlamofire()
        default: return
        }
    }
}

// MARK: Notifications

extension MainCollectionViewController {
    
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background transfer has completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension MainCollectionViewController {
    private func checkLogIn() {
        if Auth.auth().currentUser == nil {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            loginViewController.hidesBottomBarWhenPushed = true
            loginViewController.navigationItem.hidesBackButton = true
            navigationController?.pushViewController(loginViewController, animated: false)
            
            return
            
        }
    }
}
