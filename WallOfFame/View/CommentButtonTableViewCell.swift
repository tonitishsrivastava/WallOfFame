//
//  commentButtonTableViewCell.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 27/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import UIKit

class CommentButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var seeCommentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
