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
    
    private var game : Game?
    var background = SKSpriteNode(imageNamed: "background_landscape")
    private var monkey : SKSpriteNode?
    private var monkeyWalkingFrames: [SKTexture] = []
    private var bananas = [SKSpriteNode]()
    private var statues = [SKSpriteNode]()
    private var rubbles = [SKSpriteNode]()
    
    override func sceneDidLoad() {
        // Setting up the data for the game
        dataSetup()
    }
    
    func dataSetup() {
        let orientation = UIDevice.current.orientation
        var frameHeight = frame.size.height
        var frameWidth = frame.size.width
        if orientation == UIDeviceOrientation.portrait {
            // We need to use the height and width of the device to setup the graphics
            // so if the device is in portrait mode (which it should be, becuase the game is played in landscape)
            // we use height as width and width as height
            frameHeight = frame.size.width
            frameWidth = frame.size.height
        }
        
        game = Game(screneHeight: Double(frameHeight), screneWidth: Double(frameWidth),ground: Double(frameHeight / 7))
        monkey = SKSpriteNode()
    }

    override func didMove(to view: SKView) {
        buildBackground()
        buildGround()
        
        buildMonkeySprite()
        animateMonkey()
        buildStatueSprite()
        buildRubbleSprite()
        buildBananaSprite()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        monkeyJump()
    }
    func monkeyJump() {
        monkey?.physicsBody?.applyImpulse(CGVector(dx: 20.0, dy: 100.0))
        // these values seem to work well on iPhone X but not on iPad
    }
    
    // MARK: buildSprites
    func buildMonkeySprite() {
        
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
        monkey?.position = CGPoint(x: (game?.monkey?.startPosX)!, y: (game?.monkey?.startPosY)!)
        let monkeyNewHeight = game?.monkey?.CGFloatHeight
        let monkeyNewWidth = game?.monkey?.CGFloatWidth(
            oldHeight: (monkey?.size.height)!,
            oldWidth: (monkey?.size.width)!)
        monkey?.size = CGSize(width: monkeyNewWidth!, height: monkeyNewHeight!)
        
        monkey?.physicsBody = SKPhysicsBody(rectangleOf: (monkey?.size)!)
        monkey?.physicsBody?.categoryBitMask = Game.PhysicsCategory.monkey
        monkey?.physicsBody?.collisionBitMask = Game.PhysicsCategory.ground | Game.PhysicsCategory.statue | Game.PhysicsCategory.rubble
        monkey?.physicsBody?.affectedByGravity = true
        monkey?.physicsBody?.allowsRotation = false
        monkey?.physicsBody?.velocity.dx = 20
        
        addChild(monkey!)
    }
    func animateMonkey() {
        // have monkey run in place
        monkey?.run(SKAction.repeatForever(
            SKAction.animate(with: monkeyWalkingFrames, timePerFrame: 0.05, resize: false, restore: true)),
                    withKey:"walkingInPlaceMonkey")
    }
    func buildStatueSprite() {
        for statue in (game?.statues)! {
            let statueSprite = SKSpriteNode(imageNamed: "statue_00")
            let statueWidth = statue.CGFloatWidth(oldHeight: statueSprite.size.height,
                                                  oldWidth: statueSprite.size.width)
            statueSprite.size = CGSize(width: statueWidth!, height: statue.CGFloatHeight!)
            statueSprite.position = CGPoint(x: statue.startPosX!, y: statue.startPosY!)
            
            statueSprite.physicsBody = SKPhysicsBody(rectangleOf: statueSprite.size)
            statueSprite.physicsBody?.isDynamic = false
            statueSprite.physicsBody?.categoryBitMask = Game.PhysicsCategory.statue
            statueSprite.physicsBody?.affectedByGravity = false
            
            statues.append(statueSprite)
            addChild(statueSprite)
        }
    }
    func buildRubbleSprite() {
        for rubble in (game?.rubbles)! {
            let rubbleSprite = SKSpriteNode(imageNamed: "statue_05")
            let rubbleWidth = rubble.CGFloatWidth(oldHeight: rubbleSprite.size.height, oldWidth: rubbleSprite.size.width)
            rubbleSprite.size = CGSize(width: rubbleWidth!, height: rubble.CGFloatHeight!)
            rubbleSprite.position = CGPoint(x: rubble.startPosX!, y: rubble.startPosY!)
            
            rubbleSprite.physicsBody = SKPhysicsBody(rectangleOf: rubbleSprite.size)
            rubbleSprite.physicsBody?.isDynamic = false
            rubbleSprite.physicsBody?.categoryBitMask = Game.PhysicsCategory.rubble
            rubbleSprite.physicsBody?.affectedByGravity = false
            
            rubbles.append(rubbleSprite)
            addChild(rubbleSprite)
        }
    }
    func buildBananaSprite() {
        for banana in (game?.bananas)! {
            let bananaSprite = SKSpriteNode(imageNamed: "icon_jungle_bananabunch")
            let bananaWidth = banana.CGFloatWidth(oldHeight: bananaSprite.size.height, oldWidth: bananaSprite.size.width)
            bananaSprite.size = CGSize(width: bananaWidth!, height: banana.CGFloatHeight!)
            bananaSprite.position = CGPoint(x: banana.startPosX!, y: banana.startPosY!)

            bananaSprite.physicsBody = SKPhysicsBody(rectangleOf: bananaSprite.size)
            bananaSprite.physicsBody?.isDynamic = false
            bananaSprite.physicsBody?.categoryBitMask = Game.PhysicsCategory.banana
            bananaSprite.physicsBody?.affectedByGravity = false
            
            bananas.append(bananaSprite)
            addChild(bananaSprite)
        }
    }
    
    // MARK: build background
    func buildBackground() {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x: 0, y: 0)
        background.size.height = (game?.CGFloatHeight)!
        background.zPosition = -15
        self.addChild(background)
    }
    func buildGround() {
        let deviceWidth = game?.width
        let deviceHeight = game?.height
        
        var groundPoints = [CGPoint(x: 0, y: deviceHeight!),
                            CGPoint(x: deviceWidth!, y: deviceHeight!),
                            CGPoint(x: deviceWidth!, y: (game?.groundY)!),
                            CGPoint(x: 0, y: (game?.groundY)!),
                            CGPoint(x: 0, y: deviceHeight!)] // closing the box
        let ground = SKShapeNode(points: &groundPoints, count: groundPoints.count)
        //ground.fillColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        //ground.strokeColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.categoryBitMask = Game.PhysicsCategory.ground
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

extension Game {
    var CGFloatHeight: CGFloat {
        return CGFloat(height)
    }
    var CGFloatWidth: CGFloat {
        return CGFloat(width)
    }
}

extension Sprite {
    var CGFloatHeight : CGFloat? {
        return CGFloat(height!)
    }
    func CGFloatWidth(oldHeight : CGFloat, oldWidth : CGFloat) -> CGFloat? {
        return CGFloat(Double(oldWidth) * height! / Double(oldHeight))
    }
}
