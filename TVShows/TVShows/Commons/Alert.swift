//
//  Alert.swift
//  TVShows
//
//  Created by Infinum Student Academy on 25/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlertWithTextFieldAnimations(title: String, message: String, textFields: [UITextField]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { UIAlertAction in
            textFields.forEach({ (textField) in
                animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
                
                textField.text = nil
                textField.layer.add(animation, forKey: "position")
            })
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
   
}
