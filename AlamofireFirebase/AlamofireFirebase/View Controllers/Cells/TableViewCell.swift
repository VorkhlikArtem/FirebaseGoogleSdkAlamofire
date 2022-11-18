//
//  TableViewCell.swift
//  AlamofireFirebase
//
//  Created by Артём on 12.11.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseImage: WebImageView!
    @IBOutlet weak var numberOfLessons: UILabel!
    @IBOutlet weak var numberOfTests: UILabel!
    

    
    func configure(with course: Course) {
        courseNameLabel.text = course.name
        numberOfLessons.text = "Number of lessons: \(course.numberOfLessons ?? 0)"
        numberOfTests.text = "Number of tests: \(course.numberOfTests ?? 0)"
        
        courseImage.set(imageURL: course.imageUrl)
    }
    
    override func prepareForReuse() {
        courseImage.image = nil
    }
}
