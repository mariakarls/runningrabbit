//
//  Sprite.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 10/11/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation

class Sprite {
    
    var height : Double?
    // Width will be calculated relative to image size
    var startPosX: Double?
    var startPosY: Double?
    
    init(height: Double, x: Double? = 0, y: Double? = 0) {
        self.height = height
        self.startPosX = x
        self.startPosY = y
    }
    
}
