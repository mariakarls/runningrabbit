//
//  HighScore.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 24/10/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation

class HighScore: NSObject, NSCoding {

    var score: Int
    var name: String
    
    init(score: Int, name: String) {
        self.score = score
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(score, forKey: "score")
        aCoder.encode(name, forKey: "name")
    }
    convenience required init?(coder aDecoder: NSCoder) {
        let score = aDecoder.decodeInteger(forKey: "score")
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else { return nil }
        self.init(score:score,name:name)
    }
}
