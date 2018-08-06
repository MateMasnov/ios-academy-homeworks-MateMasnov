//
//  EpisodeImageTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

class EpisodeImageTableViewCell: UITableViewCell {

    //MARK: - Outlets -
    @IBOutlet weak var episodeImageView: UIImageView!
    
    //MARK: - Functions -
    override func prepareForReuse() {
        super.prepareForReuse()
        
        episodeImageView.image = nil
    }
    
    func configure(with item: ImageCellItem) {
        let url = URL(string: "https://api.infinum.academy" + item.url)
        let placeholder: UIImage = UIImage(named: "login-logo")!
        episodeImageView.contentMode = .center
        
        episodeImageView.kf.setImage(with: url, placeholder: placeholder) { [weak self] image, _, _, _ in
            if image == nil { return }
            self?.episodeImageView.contentMode = .scaleAspectFit
        }
    }
}
