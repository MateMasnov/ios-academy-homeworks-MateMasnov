//
//  HomeCollectionViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

class HomeGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var showImageView: UIImageView!
    
    func configure(with item: ShowCellItemInterface) {
        let url = URL(string: "https://api.infinum.academy" + item.imageUrl)
        let placeholder: UIImage = UIImage(named: "login-logo")!
        
        showImageView.contentMode = .center
        
        showImageView.kf.setImage(with: url, placeholder: placeholder) { image, _, _, _ in
            if image == nil { return }
            self.showImageView.contentMode = .scaleToFill
        }
    }
}
