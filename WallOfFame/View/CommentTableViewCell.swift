//
//  CommentTableViewCell.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 22/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var comment_user_image: UIImageView!
    @IBOutlet weak var comment_user_name: UILabel!
    @IBOutlet weak var comment_user_reply: UILabel!
    
    @IBOutlet weak var commentContainer: UIView!
    
    @IBOutlet weak var replyReactionView: UIView!
    
    var reactionButton: MIBadgeButton!
    
    var lastCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBadgeButton(comment: Comment?){
        
        let xConstrain = (replyReactionView.bounds.width - replyReactionView.bounds.height/1.2)/2
        let yConstrain = (replyReactionView.bounds.height - replyReactionView.bounds.height/1.5)/2
        let reactionCount = (comment!.reaction!.getReactionCount())
        reactionButton = MIBadgeButton(frame: CGRect(x: xConstrain, y: yConstrain, width: replyReactionView.bounds.height/1.2, height: replyReactionView.bounds.height/1.5))
        var _ = reactionButton.initWithFrame(frame: CGRect(x: xConstrain, y: yConstrain, width: replyReactionView.bounds.height/1.2, height: replyReactionView.bounds.height/1.5), withBadgeString: "", withBadgeInsets:  UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        let cartBarbuttonImage = UIImage(named: "drop-up-arrow")
        reactionButton.contentMode = .scaleAspectFit
        reactionButton.setImage(cartBarbuttonImage, for: UIControl.State())
        reactionButton.setImage(cartBarbuttonImage, for: .selected)
        reactionButton.badgeString = String(reactionCount)
        replyReactionView.addSubview(reactionButton)
        replyReactionView.layer.cornerRadius = 4
        replyReactionView.layer.borderWidth = 1
        replyReactionView.layer.borderColor = UIColor.black.cgColor
        replyReactionView.layer.masksToBounds = true
        
    }
    
    override func prepareForReuse() {
        // your cleanup code
        comment_user_image.image = UIImage(named: "placeHolder")
        comment_user_name.text = ""
        comment_user_reply.text = ""
        if reactionButton != nil{
            reactionButton.removeFromSuperview()
        }
        
        
    }

}
