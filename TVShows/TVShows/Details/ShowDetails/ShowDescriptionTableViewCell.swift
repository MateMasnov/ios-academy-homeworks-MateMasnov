//
//  ShowDescriptionTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

struct DescriptionCellItem {
    let title: String
    let description: String
    let numberOfEpisodes: Int
}

class ShowDescriptionTableViewCell: UITableViewCell {

    //MARK: - Outlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    
    //Mark: - Functions -
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        episodesLabel.text = nil
    }
    
    func configure(with item: DescriptionCellItem) {
        let description: String = item.description == "" ? "No description" : item.description
        let title: String = item.title == "" ? "No title" : item.title
        
        titleLabel.text = title
        descriptionLabel.text = description
        episodesLabel.text = "Episodes   \(item.numberOfEpisodes)"
    }
}
