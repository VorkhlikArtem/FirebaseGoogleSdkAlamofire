//
//  ImageViewController.swift
//  AlamofireFirebase
//
//  Created by Артём on 12.11.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var completedLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    private let url = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        completedLabel.isHidden = true
        progressView.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    func fetchImage() {
        
        NetworkManager.downloadImage(url: url) { image in
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
        }
    }
    
    func fetchDataWithAlamofire() {
        
        AlamofireNetworkManager.downloadImage(url: url) { image in
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
        }
    }
    
    func downloadLargeImageWithAlamofire() {
        AlamofireNetworkManager.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        AlamofireNetworkManager.completed = { completed in
            self.completedLabel.isHidden = false
            self.completedLabel.text = completed
        }
        AlamofireNetworkManager.downloadImageWithProgress(url: largeImageUrl) { image in
            self.progressView.isHidden = true
            self.completedLabel.isHidden = true
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
        }
    }


}
