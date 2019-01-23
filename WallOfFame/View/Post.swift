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
    
}
