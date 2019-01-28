//
//  Reaction.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 23/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import Foundation



struct Reaction {
    var like: Int?
    var haha: Int?
    var dab: Int?
    var crazy: Int?
    var meh: Int?
    var takeMyMoney: Int?
    
    init(like: Int, haha: Int, dab: Int, crazy: Int, meh: Int, takeMyMoney: Int) {
        self.crazy = crazy
        self.like = like
        self.dab = dab
        self.haha = haha
        self.meh = meh
        self.takeMyMoney = takeMyMoney
    }
    
    func getAllReactions() -> [[String:Int]]{
        let reactions = [["like":like!],["haha":haha!],["dab":dab!],["crazy":crazy!],["meh":meh!],["takeMyMoney":takeMyMoney!]]
        
        return reactions
    }
    
    func getAvailableReaction() -> [[String:Int]]{
        let reactions = [["like":like!],["haha":haha!],["dab":dab!],["crazy":crazy!],["meh":meh!],["takeMyMoney":takeMyMoney!]]
        
        var availableReaction = [[String: Int]]()
        for reaction in reactions{
            for (key, value) in reaction{
                if(value > 0){
                    availableReaction.append([key:value])
                }
            }
        }
        
        return availableReaction
    }
    
    func getReactionCount() -> Int{
        var count = 0
        if(like! > 0){
            count += 1
        }
        if(crazy! > 0){
            count += 1
        }
        if(dab! > 0){
            count += 1
        }
        if(haha! > 0){
            count += 1
        }
        if(meh! > 0){
            count += 1
        }
        if(takeMyMoney! > 0){
            count += 1
        }
        
        return count
        
    }
    
}
