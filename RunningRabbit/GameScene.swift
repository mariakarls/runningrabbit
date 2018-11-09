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
    
    // Move sprite: http://mammothinteractive.com/touches-and-moving-sprites-in-xcode-spritekit-swift-crash-course-free-tutorial/
    // Monkey sprite from tutorial: https://www.gameartguppy.com/
    // Walking bear tutorial: https://www.raywenderlich.com/144-spritekit-animations-and-texture-atlases-in-swift
    // Labrynth: https://www.thedroidsonroids.com/blog/ios/maze-game-with-spritekit
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let monkey    : UInt32 = 1
        static let statue    : UInt32 = 2
        static let diamond   : UInt32 = 3
        static let ground    : UInt32 = 4
        static let rubble    : UInt32 = 5
        static let banana    : UInt32 = 6
    }
    
    private var monkey = SKSpriteNode()
    var background = SKSpriteNode(imageNamed: "background_landscape")
    var monkeyPosition = CGPoint(x: 0, y: 0)
    var statuePositions = [CGPoint]()
    var statueHeight = CGFloat()
    var monkeyHeight = CGFloat()
    var groundPositionY = CGFloat()
    var statues = [SKSpriteNode]()
    private var monkeyWalkingFrames: [SKTexture] = []
    
    var rubblePositions = [CGPoint]()
    var rubbleHeight = CGFloat()
    var rubbles = [SKSpriteNode]()
    
    var bananaPositions = [CGPoint]()
    var bananaHeight = CGFloat()
    var bananas = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        buildBackground()
        buildGround()
        buildMonkey()
        animateMonkey()
        buildStatues()
        buildRubble()
        buildBanana()
    }
    
    override func sceneDidLoad() {
        // Setting up the data for the game
        dataSetup()
    }
    
    var frameHeight : CGFloat?
    var frameWidth : CGFloat?
    
    func dataSetup() {
        let orientation = UIDevice.current.orientation
        frameHeight = frame.size.height
        frameWidth = frame.size.width
        if orientation == UIDeviceOrientation.portrait {
            // We need to use the height and width of the device to setup the graphics
            // so if the device is in portrait mode (which it should be, becuase the game is played in landscape)
            // we use height as width and width as height
            frameHeight = frame.size.width
            frameWidth = frame.size.height
        }
        monkeyHeight = frameHeight!/5
        statueHeight = monkeyHeight
        rubbleHeight = frameHeight!/5
        bananaHeight = frameHeight!/5
        monkeyPosition = CGPoint(x: frameWidth! / 8, y: frameHeight! / 4.25)
        groundPositionY = monkeyPosition.y - monkeyHeight
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*0.2, y: groundPositionY + statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*0.3, y: groundPositionY + 1.5*statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*0.48, y: groundPositionY + 2.3*statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*0.8, y: groundPositionY + statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*1.2, y: groundPositionY + statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*1.3, y: groundPositionY + 1.5*statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*1.4, y: groundPositionY + 2*statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*1.5, y: groundPositionY + 1.5*statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*2.5, y: groundPositionY + statueHeight))
        statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*2.6, y: groundPositionY + 1.5*statueHeight))
        
        rubblePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*0.6, y: groundPositionY + rubbleHeight))
        rubblePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*2, y: groundPositionY + rubbleHeight))
        
        bananaPositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*0.48, y: groundPositionY + bananaHeight*5))
        bananaPositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*2.6, y: groundPositionY + bananaHeight*5))
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
        
        monkey.physicsBody = SKPhysicsBody(rectangleOf: monkey.size)
        monkey.physicsBody?.categoryBitMask = PhysicsCategory.monkey
        monkey.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.statue | PhysicsCategory.rubble
        monkey.physicsBody?.affectedByGravity = true
        monkey.physicsBody?.allowsRotation = false
        monkey.physicsBody?.velocity.dx = 20
        
        addChild(monkey)
    }
    
    func animateMonkey() {
        // have monkey run in place
        monkey.run(SKAction.repeatForever(
            SKAction.animate(with: monkeyWalkingFrames, timePerFrame: 0.05, resize: false, restore: true)),
                 withKey:"walkingInPlaceMonkey")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        monkeyJump()
    }
    
    func monkeyJump() {
        monkey.physicsBody?.applyImpulse(CGVector(dx: 20.0, dy: 100.0))
        // these values seem to work well on iPhone X but not on iPad
    }
    
    func buildStatues() {
        for i in 0..<statuePositions.count {
            let statue = SKSpriteNode(imageNamed: "statue_00")
            let statueWidth = statue.size.width * (statueHeight/statue.size.height)
            statue.size = CGSize(width: statueWidth, height: statueHeight)
            statue.position = statuePositions[i]
            
            statue.physicsBody = SKPhysicsBody(rectangleOf: statue.size)
            statue.physicsBody?.isDynamic = false
            statue.physicsBody?.categoryBitMask = PhysicsCategory.statue
            statue.physicsBody?.affectedByGravity = false
            
            statues.append(statue)
            addChild(statue)
            
        }
    }
    func buildRubble() {
        for i in 0..<rubblePositions.count {
            let rubble = SKSpriteNode(imageNamed: "statue_05")
            let rubbleWidth = rubble.size.width * (statueHeight/rubble.size.height)
            rubble.size = CGSize(width: rubbleWidth, height: rubbleHeight)
            rubble.position = rubblePositions[i]
            rubble.physicsBody = SKPhysicsBody(rectangleOf: rubble.size) //The size doesn't match the physic size of the rubble
            rubble.physicsBody?.isDynamic = false
            rubble.physicsBody?.categoryBitMask = PhysicsCategory.rubble
            rubble.physicsBody?.affectedByGravity = false
            rubbles.append(rubble)
            addChild(rubble)
            
        }
    }
    func buildBanana() {
        for i in 0..<bananaPositions.count {
            let banana = SKSpriteNode(imageNamed: "statue_05")
            let bananaWidth = banana.size.width * (statueHeight/banana.size.height)
            banana.size = CGSize(width: bananaWidth, height: bananaHeight)
            banana.position = bananaPositions[i]
            banana.physicsBody = SKPhysicsBody(rectangleOf: banana.size) //The size doesn't match the physic size of the bananas
            banana.physicsBody?.isDynamic = false
            banana.physicsBody?.categoryBitMask = PhysicsCategory.banana
            banana.physicsBody?.affectedByGravity = false
            bananas.append(banana)
            addChild(banana)
            
        }
    }
    
    func buildBackground() {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: 0)
        background.size.height = frameHeight!
        background.zPosition = -15
        self.addChild(background)
    }
    func buildGround() {
        let deviceWidth = frameWidth!
        let deviceHeight = frameHeight!
        
        var groundPoints = [CGPoint(x: 0, y: deviceHeight),
                            CGPoint(x: deviceWidth, y: deviceHeight),
                            CGPoint(x: deviceWidth, y: 4*groundPositionY),
                            CGPoint(x: 0, y: 4*groundPositionY),
                            CGPoint(x: 0, y: deviceHeight)] // closing the box
        let ground = SKShapeNode(points: &groundPoints, count: groundPoints.count)
        //ground.fillColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        //ground.strokeColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.restitution = 0.75
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0
        addChild(ground)
    }
    
    
    // Didn't work to create a variable for the movment of the background and statues
    //let changeInBackground = 2.0
    
    override func update(_ Time: CFTimeInterval) {
        // Move the background and obstacles
        
        background.position = CGPoint(x: background.position.x - 2, y: background.position.y)
        
        // Probably only want to do this for the visible ones, on screen
        for statue in statues {
            statue.position = CGPoint(x: statue.position.x - 2, y: statue.position.y)
        }
        for rubble in rubbles {
            rubble.position = CGPoint(x: rubble.position.x - 2, y: rubble.position.y)
        }
        for banana in bananas {
            banana.position = CGPoint(x: banana.position.x - 2, y: banana.position.y)
        }
        
        /*
         
         // to repeat the background
        if(background.position.x < -background.size.width + frame.size.width)
        {
            background.position = CGPoint(x: background.position.x, y: background.position.y)
        }
         */
        
    }
}
