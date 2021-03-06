//
//  HomeListCollectionViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

class HomeListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        listImageView.image = nil
    }
    
    func configure(with item: ShowCellItemInterface) {
        let url = URL(string: Constants.URL.baseDomainUrl + item.imageUrl)
        let placeholder: UIImage = UIImage(named: "photo-logo")!
        
        listImageView.contentMode = .center
        titleLabel.text = item.title
        
        listImageView.kf.setImage(with: url, placeholder: placeholder) { [weak self] image, _, _, _ in
            if image == nil { return }
            self?.listImageView.contentMode = .scaleAspectFit
        }
    }
}
