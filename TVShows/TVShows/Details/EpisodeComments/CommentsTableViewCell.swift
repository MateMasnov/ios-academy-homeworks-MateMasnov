//
//  CommentsTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 01/08/2018.
//  Copyright © 2018 Mate Masnov. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentsUserLabel: UILabel!
    @IBOutlet weak var commentsTextLabel: UILabel!
    
    override func prepareForReuse() {
        commentsTextLabel.text = nil
        commentsUserLabel.text = nil
    }
    
    func configure(with item: CommentsCellItemInterface) {
        commentsUserLabel.text = item.userEmail
        commentsTextLabel.text = item.text
    }
}
