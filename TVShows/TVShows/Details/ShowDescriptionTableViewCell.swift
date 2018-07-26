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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        episodesLabel.text = nil
    }
    
    func configure(with item: DescriptionCellItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        episodesLabel.text = "Episodes   \(item.numberOfEpisodes)"
    }
}
