//
//  Comment.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 23/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import Foundation


struct Comment {
    var comment_id: String?
    var comment:String?
    var user: User?
    var reaction: Reaction?
    var date: Date?
    
    init(comment_id: String, comment: String, user: User, reaction: Reaction, date: Date) {
        self.comment_id = comment_id
        self.comment = comment
        self.user = user
        self.reaction = reaction
        self.date = date
    }
    
}
