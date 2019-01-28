//
//  Post.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 23/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import Foundation



struct Post {
    var date: Date?
    var name: String?
    var reaction: Reaction?
    var user: User?
    var id: String?
    var comments: [Comment]?
    
    init(date: Date, name: String, reaction: Reaction, user: User, id: String, comments: [Comment]) {
        self.date = date
        self.name = name
        self.reaction = reaction
        self.comments = comments
        self.id = id
        self.user = user
    }
    
}
