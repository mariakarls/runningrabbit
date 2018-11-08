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
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let bunny     : UInt32 = 1
        static let block     : UInt32 = 2
        static let diamond   : UInt32 = 3
    }
    
    private var bunny = SKSpriteNode()
    var background = SKSpriteNode(imageNamed: "background")

    
    private var bunnyWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)
        buildBunny()
        animateBunny()
        buildBlocks()
    }
    
    // would maybe be better to use optionals?
    var bunnyPosition = CGPoint(x: 0, y: 0)
    var blockPositions = [CGPoint]()
    var blockHeight = 40
    
    override func sceneDidLoad() {
        bunnyPosition = CGPoint(x: frame.maxX / 8, y: frame.maxY / 10)
        blockPositions.append(CGPoint(x: (bunnyPosition.x) + frame.maxX*0.2, y: frame.maxY/10))
        blockPositions.append(CGPoint(x: (bunnyPosition.x) + frame.maxX*0.4, y: frame.maxY/10 + CGFloat(2*blockHeight)))
    }

    func buildBlocks() {
        let block1 = SKSpriteNode(imageNamed: "block_grass")
        //block1.size = CGSize(width: blockHeight, height: blockHeight)
        block1.position = blockPositions[0]
        addChild(block1)
        
        let block2 = SKSpriteNode(imageNamed: "block_grass")
        //block2.size = CGSize(width: blockHeight, height: blockHeight)
        block2.position = blockPositions[1]
        addChild(block2)
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
        bunny.position = CGPoint(x: 100, y: 70) //bunnyPosition
        bunny.xScale = bunny.xScale * -1;
        //bunny.size = CGSize(width: dust height: blockHeight)
        
        /*
        bunny.physicsBody = SKPhysicsBody(rectangleOf: bunny.size) // size is nil
        bunny.physicsBody?.isDynamic = true
        bunny.physicsBody?.categoryBitMask = PhysicsCategory.bunny
        bunny.physicsBody?.contactTestBitMask = PhysicsCategory.diamond
        bunny.physicsBody?.collisionBitMask = PhysicsCategory.none // not sure if this is correct ?
        */
        addChild(bunny)
        
        
        // Determine speed of the monster
        let actualDuration = 10 // random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: frame.maxX, y: bunny.position.y), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        /*
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
 */
        bunny.run(SKAction.sequence([actionMove, /*loseAction,*/ actionMoveDone])/*, withKey:"bunnyRunning"*/)
        
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
        bunnyJump()
        //let touch = touches.first!
        //let location = touch.location(in: self)
        //moveBunny(location: location)
    }
    
    func bunnyJump() {
        
        let location = CGPoint(x: bunny.position.x, y: bunny.position.y + frame.maxY*0.1)
        let locationDown = CGPoint(x: bunny.position.x, y: bunny.position.y)
        let moveActionUp = SKAction.move(to: location, duration:(TimeInterval(3)))
        let moveActionDown = SKAction.move(to: locationDown, duration:(TimeInterval(1)))
        let moveActionWithDone = SKAction.sequence([moveActionUp, moveActionDown])
        bunny.run(moveActionWithDone, withKey:"bunnyJumping")
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
