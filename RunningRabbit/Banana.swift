//
//  Banana.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 09/11/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation

class Banana : Sprite {
    
    var score = 1
    
    public func updateScore() {
        score = score * 2
    }
}
