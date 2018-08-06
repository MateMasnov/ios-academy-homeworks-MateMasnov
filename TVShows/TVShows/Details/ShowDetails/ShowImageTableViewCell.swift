//
//  ShowImageTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit
import Kingfisher

struct ImageCellItem {
    let url: String
}

class ShowImageTableViewCell: UITableViewCell {

    //MARK: - Outlets -
    @IBOutlet weak var showImageView: UIImageView!
    
    //MARK: - Functions -
    override func prepareForReuse() {
        super.prepareForReuse()
        
        showImageView.image = nil
    }
    
    func configure(with item: ImageCellItem) {
        let url = URL(string: "https://api.infinum.academy" + item.url)
        let placeholder: UIImage = UIImage(named: "login-logo")!
        showImageView.contentMode = .center
        
        showImageView.kf.setImage(with: url, placeholder: placeholder) { [weak self] image, _, _, _ in
            if image == nil { return }
            self?.showImageView.contentMode = .scaleToFill
        }
    }
}
