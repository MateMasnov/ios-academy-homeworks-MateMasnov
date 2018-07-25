//
//  Alert.swift
//  TVShows
//
//  Created by Infinum Student Academy on 25/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation
import UIKit

func presentAlert(title: String, message: String, controller: UIViewController) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    controller.present(alert, animated: true, completion: nil)
}

