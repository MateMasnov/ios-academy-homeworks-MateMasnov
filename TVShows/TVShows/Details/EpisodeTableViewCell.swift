//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

struct EpisodeCellItem {
    let title: String
    let details: String
}

class EpisodeTableViewCell: UITableViewCell {

    //MARK: - Outlets -
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Functions -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        detailsLabel.text = nil
        titleLabel.text = nil
    }
    
    func configure(with item: EpisodeCellItem) {
        titleLabel.text = item.title
        detailsLabel.text = item.details
    }
}
