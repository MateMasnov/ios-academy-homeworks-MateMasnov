//
//  podProtocols.swift
//  TVShows
//
//  Created by Infinum Student Academy on 24/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol Progressable {
    func showSpinner()
    func hideSpinner()
}

extension Progressable where Self: UIViewController {
    func showSpinner() {
        SVProgressHUD.show()
    }
    
    func hideSpinner() {
        SVProgressHUD.dismiss()
    }
}
