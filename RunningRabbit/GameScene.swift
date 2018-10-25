//
//  GameScene.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 25/10/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    // Move sprite
    // http://mammothinteractive.com/touches-and-moving-sprites-in-xcode-spritekit-swift-crash-course-free-tutorial/
    
    var player = SKSpriteNode()

    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
        }
    }
    
    func spawnPlayer(){

    }
    
    override func update(_ Time: CFTimeInterval) {
        /*Called before each frame is rendered */
    }
}
