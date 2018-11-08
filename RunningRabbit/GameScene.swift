//
//  GameScene.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 25/10/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class GameScene: SKScene {
    
    // Move sprite
    // http://mammothinteractive.com/touches-and-moving-sprites-in-xcode-spritekit-swift-crash-course-free-tutorial/
    
    // Monkey sprite from tutorial
    // https://www.gameartguppy.com/shop/dust-monkey-game-character/
    
    
    // Walking bear tutorial:
    // https://www.raywenderlich.com/144-spritekit-animations-and-texture-atlases-in-swift
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let monkey    : UInt32 = 1
        static let block     : UInt32 = 2
        static let diamond   : UInt32 = 3
    }
    
    private var monkey = SKSpriteNode()
    var background = SKSpriteNode(imageNamed: "background_landscape")

    
    private var monkeyWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: 0)
        background.size.height = frame.size.height
        background.zPosition = -15
        self.addChild(background)
        
        buildMonkey()
        animateMonkey()
        buildBlocks()
    }
    
    // would maybe be better to use optionals?
    var monkeyPosition = CGPoint(x: 0, y: 0)
    var statuePositions = [CGPoint]()
    var statueHeight = CGFloat()
    var monkeyHeight = CGFloat()
    var groundPositionY = CGFloat()
    
    override func sceneDidLoad() {
        monkeyHeight = frame.size.height/5
        statueHeight = monkeyHeight
        monkeyPosition = CGPoint(x: frame.maxX / 8, y: frame.maxY / 4.5)
        groundPositionY = monkeyPosition.y - monkeyPosition.y
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frame.maxX*0.2, y: groundPositionY + statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frame.maxX*0.4, y: groundPositionY + 2*statueHeight))
    }

    func buildBlocks() {
        let statue1 = SKSpriteNode(imageNamed: "statue_00")
        let statueWidth = statue1.size.width * (statueHeight/statue1.size.height)
        statue1.size = CGSize(width: statueWidth, height: statueHeight)
        statue1.position = statuePositions[0]
        addChild(statue1)
        
        let statue2 = SKSpriteNode(imageNamed: "statue_00")
        statue2.size = CGSize(width: statueWidth, height: statueHeight)
        statue2.position = statuePositions[1]
        addChild(statue2)
    }
    
    func buildMonkey() {
        
        let monkeyAnimatedAtlas = SKTextureAtlas(named: "MonkeyImages")
        var runFrames: [SKTexture] = []
        
        let numImages = monkeyAnimatedAtlas.textureNames.count
        for i in 1...numImages {
            let monkeyTextureName = "monkey_run_\(i)@2x.png"
            runFrames.append(monkeyAnimatedAtlas.textureNamed(monkeyTextureName))
        }
        monkeyWalkingFrames = runFrames
        
        let firstFrameTexture = monkeyWalkingFrames[0]
        monkey = SKSpriteNode(texture: firstFrameTexture)
        monkey.position = monkeyPosition
        let monkeyNewHeight = monkeyHeight
        let monkeyNewWidth = monkey.size.width * (monkeyNewHeight/monkey.size.height)
        monkey.size = CGSize(width: monkeyNewWidth, height: monkeyNewHeight)
        
        /*
        monkey.physicsBody = SKPhysicsBody(rectangleOf: monkey.size) // size is nil
        monkey.physicsBody?.isDynamic = true
        monkey.physicsBody?.categoryBitMask = PhysicsCategory.monkey
        monkey.physicsBody?.contactTestBitMask = PhysicsCategory.diamond
        monkey.physicsBody?.collisionBitMask = PhysicsCategory.none // not sure if this is correct ?
        */
        addChild(monkey)
        
        
        // Determine speed of the monster
        let actualDuration = 10 // random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: frame.maxX, y: monkey.position.y), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        /*
        let loseAction = SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
 */
        monkey.run(SKAction.sequence([actionMove, /*loseAction,*/ actionMoveDone])/*, withKey:"monkeyRunning"*/)
        
    }
    
    func animateMonkey() {
        // have monkey run in place
        monkey.run(SKAction.repeatForever(
            SKAction.animate(with: monkeyWalkingFrames,
                             timePerFrame: 0.05,
                             resize: false,
                             restore: true)),
                 withKey:"walkingInPlaceMonkey")
    }
    
    func monkeyMoveEnded() {
        // to be called when monkey arrives at end of screen
        monkey.removeAllActions()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        monkeyJump()
        //let touch = touches.first!
        //let location = touch.location(in: self)
        //moveMonkey(location: location)
    }
    
    func monkeyJump() {
        
        let location = CGPoint(x: monkey.position.x, y: monkey.position.y + frame.maxY*0.1)
        let locationDown = CGPoint(x: monkey.position.x, y: monkey.position.y)
        let moveActionUp = SKAction.move(to: location, duration:(TimeInterval(3)))
        let moveActionDown = SKAction.move(to: locationDown, duration:(TimeInterval(1)))
        let moveActionWithDone = SKAction.sequence([moveActionUp, moveActionDown])
        monkey.run(moveActionWithDone, withKey:"monkeyJumping")
    }
    
    func moveMonkey(location: CGPoint) {
        var multiplierForDirection: CGFloat
        
        let monkeySpeed = frame.size.width / 3.0
        
        let moveDifference = CGPoint(x: location.x - monkey.position.x, y: location.y - monkey.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)

        let moveDuration = distanceToMove / monkeySpeed
        
        if moveDifference.x < 0 {
            multiplierForDirection = 1.0
        } else {
            multiplierForDirection = -1.0
        }
        monkey.xScale = abs(monkey.xScale) * multiplierForDirection
        
        if monkey.action(forKey: "walkingInPlaceMonkey") == nil {
            // if legs are not moving, start them
            animateMonkey()
        }
        let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
        
        let doneAction = SKAction.run({ [weak self] in
            self?.monkeyMoveEnded()
        })
        
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        monkey.run(moveActionWithDone, withKey:"monkeyMoving")
        
    }
    
    override func update(_ Time: CFTimeInterval) {
        // Called before each frame is rendered
        
        background.position = CGPoint(x: background.position.x - 2, y: background.position.y)
        
        /*
        if(background.position.x < -background.size.width + frame.size.width)
        {
            background.position = CGPoint(x: background.position.x, y: background.position.y)
        }
 */
        

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
    

 
 */
}
