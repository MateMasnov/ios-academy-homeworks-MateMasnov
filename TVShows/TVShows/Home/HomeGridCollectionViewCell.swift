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
    
    override func prepareForReuse() {
        super.prepareForReuse()

        showImageView.image = nil
    }
    
    func configure(with item: ShowCellItemInterface) {
        let url = URL(string: Constants.URL.baseDomainUrl + item.imageUrl)
        let placeholder: UIImage = UIImage(named: "photo-logo")!
        
        showImageView.contentMode = .center
        
        showImageView.kf.setImage(with: url, placeholder: placeholder) { [weak self] image, _, _, _ in
            if image == nil { return }
            self?.showImageView.contentMode = .scaleAspectFit
        }
    }
}
