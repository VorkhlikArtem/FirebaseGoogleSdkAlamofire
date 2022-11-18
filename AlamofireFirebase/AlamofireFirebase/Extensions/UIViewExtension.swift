//
//  Extensions.swift
//  AlamofireFirebase
//
//  Created by Артём on 15.11.2022.
//

import UIKit

let topColor = #colorLiteral(red: 0.9254902005, green: 0.3750879053, blue: 0.001446257725, alpha: 1)
let bottomColor = #colorLiteral(red: 0.62532011, green: 0.268699662, blue: 0.7254902124, alpha: 1)

extension UIView {
    
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
