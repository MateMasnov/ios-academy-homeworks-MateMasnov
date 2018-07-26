//
//  HomeTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 25/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

struct HomeCellItem {
    let title: String
}

class HomeTableViewCell: UITableViewCell {

    //MARK: - Outlets -
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Cell functions -
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
        
        titleLabel.text = nil
    }
    
    func configure(with item: ShowCellItemInterface) {
        titleLabel.text = item.title
    }

}
