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
    
    // Bunny sprite from tutorial
    // https://www.gameartguppy.com/shop/dust-bunny-game-character/
    
    
    // Walking bear tutorial:
    // https://www.raywenderlich.com/144-spritekit-animations-and-texture-atlases-in-swift
    
    private var bunny = SKSpriteNode()
    var background = SKSpriteNode(imageNamed: "background")

    
    private var bunnyWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)
        buildBunny()
        animateBunny()
    }
    
    func buildBunny() {
        
        let bunnyAnimatedAtlas = SKTextureAtlas(named: "DustBunnyImages")
        var walkFrames: [SKTexture] = []
        
        let numImages = bunnyAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let bunnyTextureName = "dustbunny_run\(i)@2x.png"
            walkFrames.append(bunnyAnimatedAtlas.textureNamed(bunnyTextureName))
        }
        bunnyWalkingFrames = walkFrames
        
        let firstFrameTexture = bunnyWalkingFrames[0]
        bunny = SKSpriteNode(texture: firstFrameTexture)
        bunny.position = CGPoint(x: frame.maxX / 8, y: frame.maxY / 5)
        bunny.xScale = bunny.xScale * -1;
        addChild(bunny)
    }
    
    func animateBunny() {
        bunny.run(SKAction.repeatForever(
            SKAction.animate(with: bunnyWalkingFrames,
                             timePerFrame: 0.3,
                             resize: false,
                             restore: true)),
                 withKey:"walkingInPlaceBunny")
    }
    
    func bunnyMoveEnded() {
        // to be called when bunny arrives at end of screen
        bunny.removeAllActions()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        moveBunny(location: location)
    }
    
    
    func moveBunny(location: CGPoint) {
        var multiplierForDirection: CGFloat
        
        let bunnySpeed = frame.size.width / 3.0
        
        let moveDifference = CGPoint(x: location.x - bunny.position.x, y: location.y - bunny.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)

        let moveDuration = distanceToMove / bunnySpeed
        
        if moveDifference.x < 0 {
            multiplierForDirection = 1.0
        } else {
            multiplierForDirection = -1.0
        }
        bunny.xScale = abs(bunny.xScale) * multiplierForDirection
        
        if bunny.action(forKey: "walkingInPlaceBunny") == nil {
            // if legs are not moving, start them
            animateBunny()
        }
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
        
        let doneAction = SKAction.run({ [weak self] in
            self?.bunnyMoveEnded()
        })
        
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        bunny.run(moveActionWithDone, withKey:"bunnyMoving")
        
    }

    
    
    /*
    var player = SKSpriteNode()

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when a touch begins
        
        for touch in touches {
            
        }
    }
    
    func spawnPlayer(){

    }
    
    override func update(_ Time: CFTimeInterval) {
        // Called before each frame is rendered
    }
 
 */
}
