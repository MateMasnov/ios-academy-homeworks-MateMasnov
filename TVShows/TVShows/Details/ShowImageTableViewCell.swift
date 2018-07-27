//
//  ShowImageTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

struct ImageCellItem {
    let url: String
}

class ShowImageTableViewCell: UITableViewCell {

    //MARK: - Outlets -
    @IBOutlet weak var showImageView: UIImageView!
    
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
        //nesto
    }
    
    func configure(with item: ImageCellItem) {
        //kingfisher pod moras
    }
}
