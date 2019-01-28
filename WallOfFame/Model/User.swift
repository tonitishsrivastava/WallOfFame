//
//  User.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 23/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import Foundation


struct User {
    var user_id: String?
    var name: String?
    var videoUrl: String?
    var imageUrl: String?
    var date: Date?
    
    init(user_id: String, name: String, videoUrl: String, imageUrl: String, date: Date) {
        self.user_id = user_id
        self.name = name
        self.videoUrl = videoUrl
        self.imageUrl = imageUrl
        self.date = date
    }
    
}
