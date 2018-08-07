//
//  EpisodeDetailsTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit


class EpisodeDetailsTableViewCell: UITableViewCell {

    //MARK: - Outlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    //MARK: - Functions -
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        detailsLabel.text = nil
    }

    func configure(with item: EpisodeCellItemInterface) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        detailsLabel.text = "S\(item.season) E\(item.episode)"
    }
}
