//
//  Diamond.swift
//  RunningRabbit
//
//  Created by Lea Fog-Fredsgaard on 16/11/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation

class Diamond : Sprite {
    
    var isFinal = false
    
    var score = 5
    
    public func updateScore() {
        score = score * 2
    }
    
    init(height: Double, x: Double?, y: Double?, isFinal: Bool?) {
        super.init(height: height, x: x, y: y)
        self.isFinal = isFinal!
    }
}
