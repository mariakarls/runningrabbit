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
import AVFoundation
import CoreAudio

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Move sprite: http://mammothinteractive.com/touches-and-moving-sprites-in-xcode-spritekit-swift-crash-course-free-tutorial/
    // Monkey sprite from tutorial: https://www.gameartguppy.com/
    // Walking bear tutorial: https://www.raywenderlich.com/144-spritekit-animations-and-texture-atlases-in-swift
    // Labrynth: https://www.thedroidsonroids.com/blog/ios/maze-game-with-spritekit
    
    private var game : Game?
    var background1 = SKSpriteNode(imageNamed: "background_landscape")
    var background2 = SKSpriteNode(imageNamed: "background_landscape2")
    private var monkey : SKSpriteNode?
    private var monkeyWalkingFrames: [SKTexture] = []
    private var bananas = [SKSpriteNode]()
    private var statues = [SKSpriteNode]()
    private var rubbles = [SKSpriteNode]()
    private var diamonds = [SKSpriteNode]()
    private var morefire = [SKSpriteNode]()
    private var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    let userDefaults = UserDefaults.standard
    var changeInBackground = 1.0
    var levelNumber = 0
    
    let scoreLabel = SKLabelNode()
    let pauseButton = SKSpriteNode(imageNamed: "pause")
    let playButton = SKSpriteNode(imageNamed: "play")
    var isPause = false
    var isGameOver = false {
        didSet {
            if isGameOver {
                isPause = true
                var highScoreList = HighScore.getData(from: userDefaults)
                if (highScoreList == nil) {
                    // First time user runs the app, we need to store datastructure to be able to keep high scores
                    highScoreList = setupHighScoreList()
                    HighScore.setData(from: userDefaults, with: highScoreList!)
                }
                if (score > highScoreList![(game?.highScoreCount)!-1].score) {
                    // You only get a new high score if you beat the pervious ones
                    // if you get equal score as the 10th seat then you get nothing
                    userDefaults.set(score, forKey: DefaultKeys.currentPlayerScore.rawValue)
                    self.gameViewController?.performSegue(withIdentifier: "showGameOverController", sender: self)
                }
                else {
                    self.gameViewController?.performSegue(withIdentifier: "showHighScoreController", sender: self)
                }
            }
        }
    }
    weak var gameViewController : GameViewController? = nil

    let LEVEL_THRESHOLD: Float = -10.0

    private func setupHighScoreList() -> Array<HighScore> {
        var returnList = Array<HighScore>()
        for _ in 0...(game?.highScoreCount)!-1 {
            returnList.append(HighScore(score: 0, name: ""))
        }
        return returnList
    }
    
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
        
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: frameWidth - frameWidth/20, y: frameHeight - frameHeight/10)
        pauseButton.name = "pause"
        pauseButton.size = scoreLabel.frame.size
        pauseButton.position = CGPoint(x: frameWidth/20, y: frameHeight - frameHeight/10 + pauseButton.size.height/2)
        pauseButton.isUserInteractionEnabled = false
        playButton.name = "play"
        playButton.size = scoreLabel.frame.size
        playButton.position = CGPoint(x: frameWidth/20, y: frameHeight - frameHeight/10 + pauseButton.size.height/2)
        playButton.isUserInteractionEnabled = false
        playButton.isHidden = true
    }
    
    override func didMove(to view: SKView) {
        buildBackground()
        buildGround()
        
        buildMonkeySprite()
        animateMonkey()
        buildStatueSprite(gameStatues: (game?.statues)!)
        buildRubbleSprite(gameRubbles: (game?.rubbles)!)
        buildBananaSprite(gameBananas: (game?.bananas)!)
        buildDiamondSprite(gameDiamonds: (game?.diamonds)!)
        buildFireSprite(gameFires: (game?.morefire)!)
        addChild(scoreLabel)
        addChild(pauseButton)
        addChild(playButton)
        
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches
        {
            let location = touch.location(in: self)
            
            if pauseButton.contains(location) {
                isPause = !isPause
                pauseButton.isHidden = !pauseButton.isHidden
                playButton.isHidden = !playButton.isHidden
                monkey?.isPaused = !(monkey?.isPaused)!
            } else {
                if !isPause && monkey?.physicsBody?.velocity.dy == 0 {
                    // Don't want the monkey being able to jump while in the air
                    monkeyJump()
                }
            }
        }
    }
    
    func monkeyJump() {
        monkey?.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 45))
        //monkey?.physicsBody?.applyImpulse(CGVector(dx: (game?.width)!/500, dy: (game?.statueHeight)!/2.0))
        // these values seem to work well on iPhone X but not on iPad
    }
    
    // MARK: collision detection
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        
        if (bodyA == Game.PhysicsCategory.monkey && bodyB == Game.PhysicsCategory.banana) {
            if let banana = contact.bodyB.node as? SKSpriteNode {
                collectBanana(banana: banana)
            }
        } else if (bodyA == Game.PhysicsCategory.monkey && bodyB == Game.PhysicsCategory.diamond) {
            if let diamond = contact.bodyB.node as? SKSpriteNode {
                collectDiamond(diamond: diamond)
            }
        } else if (bodyA == Game.PhysicsCategory.monkey && bodyB == Game.PhysicsCategory.fire) {
            isGameOver = true
        }
    }
    
    func collectBanana(banana : SKSpriteNode) {
        score += 1
        removeChildren(in: [banana])
        if let index = bananas.index(of: banana) {
            bananas.remove(at: index)
        }
    }
    func collectDiamond(diamond : SKSpriteNode) {
        let currentDiamond = game?.diamonds.filter{ $0.startPosX! == (diamond.userData?.value(forKey: "xPos") as? Double) }.first
        
        removeChildren(in: [diamond])
        if let index = diamonds.index(of: diamond) {
            diamonds.remove(at: index)
        }
        
        score += (currentDiamond?.score)!
        if (currentDiamond?.isFinal)! {
            monkey?.physicsBody?.velocity.dx *= 1.1
            changeInBackground *= 1.1
            game!.nextLevel()
            game?.createMoreSprites()
        }
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
        
        monkey?.physicsBody = SKPhysicsBody(texture: firstFrameTexture, size: (monkey?.size)!)
        //monkey?.physicsBody = SKPhysicsBody(rectangleOf: (monkey?.size)!)
        monkey?.physicsBody?.categoryBitMask = Game.PhysicsCategory.monkey
        monkey?.physicsBody?.collisionBitMask = Game.PhysicsCategory.ground | Game.PhysicsCategory.statue | Game.PhysicsCategory.rubble | Game.PhysicsCategory.diamond
        monkey?.physicsBody?.affectedByGravity = true
        monkey?.physicsBody?.allowsRotation = false
        monkey?.physicsBody?.velocity.dx = 1
        
        addChild(monkey!)
    }
    func animateMonkey() {
        if isPause {
            return
        }
        
        // have monkey run in place
        monkey?.run(SKAction.repeatForever(
            SKAction.animate(with: monkeyWalkingFrames, timePerFrame: 0.05, resize: false, restore: true)),
                    withKey:"walkingInPlaceMonkey")
    }
    func buildStatueSprite(gameStatues: [Statue]) {
        for statue in gameStatues {
            let statueSprite = SKSpriteNode(imageNamed: "statue_00")
            let statueWidth = statue.CGFloatWidth(oldHeight: statueSprite.size.height,
                                                  oldWidth: statueSprite.size.width)
            statueSprite.size = CGSize(width: statueWidth!, height: statue.CGFloatHeight!)
            statueSprite.position = CGPoint(x: statue.startPosX!, y: statue.startPosY!)
            
            statueSprite.physicsBody = SKPhysicsBody(rectangleOf: statueSprite.size)
            statueSprite.physicsBody?.isDynamic = false
            statueSprite.physicsBody?.categoryBitMask = Game.PhysicsCategory.statue
            statueSprite.physicsBody?.affectedByGravity = false
            statueSprite.physicsBody?.restitution = 0
            
            statues.append(statueSprite)
            addChild(statueSprite)
        }
    }
    func buildRubbleSprite(gameRubbles: [Rubble]) {
        for rubble in gameRubbles {
            let rubbleSprite = SKSpriteNode(imageNamed: "statue_05")
            let rubbleWidth = rubble.CGFloatWidth(oldHeight: rubbleSprite.size.height, oldWidth: rubbleSprite.size.width)
            rubbleSprite.size = CGSize(width: rubbleWidth!, height: rubble.CGFloatHeight!)
            rubbleSprite.position = CGPoint(x: rubble.startPosX!, y: rubble.startPosY!)
            
            rubbleSprite.physicsBody = SKPhysicsBody(rectangleOf: rubbleSprite.size)
            rubbleSprite.physicsBody?.isDynamic = false
            rubbleSprite.physicsBody?.categoryBitMask = Game.PhysicsCategory.rubble
            rubbleSprite.physicsBody?.affectedByGravity = false
            rubbleSprite.physicsBody?.restitution = 0
            
            rubbles.append(rubbleSprite)
            addChild(rubbleSprite)
        }
    }
    func buildBananaSprite(gameBananas: [Banana]) {
        for banana in gameBananas {
            let bananaSprite = SKSpriteNode(imageNamed: "icon_jungle_bananabunch")
            let bananaWidth = banana.CGFloatWidth(oldHeight: bananaSprite.size.height, oldWidth: bananaSprite.size.width)
            bananaSprite.size = CGSize(width: bananaWidth!, height: banana.CGFloatHeight!)
            bananaSprite.position = CGPoint(x: banana.startPosX!, y: banana.startPosY!)
            
            bananaSprite.physicsBody = SKPhysicsBody(rectangleOf: bananaSprite.size)
            bananaSprite.physicsBody?.isDynamic = false
            bananaSprite.physicsBody?.categoryBitMask = Game.PhysicsCategory.banana
            bananaSprite.physicsBody?.affectedByGravity = false
            bananaSprite.physicsBody?.restitution = 0
            bananaSprite.physicsBody?.contactTestBitMask = Game.PhysicsCategory.monkey
            
            bananas.append(bananaSprite)
            addChild(bananaSprite)
        }
    }
    func buildDiamondSprite(gameDiamonds: [Diamond]) {
        for diamond in gameDiamonds {
            var diamondSprite: SKSpriteNode!
            if diamond.isFinal {
                diamondSprite = SKSpriteNode(imageNamed: "diamond_red")
            } else {
                diamondSprite = SKSpriteNode(imageNamed: "diamond_blue")
            }

            let diamondWidth = diamond.CGFloatWidth(oldHeight: diamondSprite.size.height, oldWidth: diamondSprite.size.width)
            diamondSprite.size = CGSize(width: diamondWidth!, height: diamond.CGFloatHeight!)
            diamondSprite.position = CGPoint(x: diamond.startPosX!, y: diamond.startPosY!)
            diamondSprite.userData = NSMutableDictionary()
            diamondSprite.userData?.setValue(diamond.startPosX!, forKeyPath: "xPos")
            
            diamondSprite.physicsBody = SKPhysicsBody(rectangleOf: diamondSprite.size)
            diamondSprite.physicsBody?.isDynamic = false
            diamondSprite.physicsBody?.categoryBitMask = Game.PhysicsCategory.diamond
            diamondSprite.physicsBody?.affectedByGravity = false
            diamondSprite.physicsBody?.restitution = 0
            diamondSprite.physicsBody?.contactTestBitMask = Game.PhysicsCategory.monkey
            
            diamonds.append(diamondSprite)
            addChild(diamondSprite)
        }
    }
    
    func buildFireSprite(gameFires: [Fire]) {
        for fire in gameFires {
            let fireSprite = SKSpriteNode(imageNamed: "fireball_1")
            let fireWidth = fire.CGFloatWidth(oldHeight: fireSprite.size.height, oldWidth: fireSprite.size.width)
            fireSprite.size = CGSize(width: fireWidth!, height: fire.CGFloatHeight!)
            fireSprite.position = CGPoint(x: fire.startPosX!, y: fire.startPosY!)
            
            fireSprite.physicsBody = SKPhysicsBody(rectangleOf: fireSprite.size)
            fireSprite.physicsBody?.isDynamic = false
            fireSprite.physicsBody?.categoryBitMask = Game.PhysicsCategory.fire
            fireSprite.physicsBody?.affectedByGravity = false
            fireSprite.physicsBody?.restitution = 0
            fireSprite.physicsBody?.contactTestBitMask = Game.PhysicsCategory.monkey
            
            morefire.append(fireSprite)
            addChild(fireSprite)
        }
    }
    // MARK: build background
    func buildBackground() {
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        background1.size.height = (game?.CGFloatHeight)!
        background1.zPosition = -15
        self.addChild(background1)
        
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width-1, y: 0)
        background2.size.height = (game?.CGFloatHeight)!
        background2.zPosition = -15
        self.addChild(background2)
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
        ground.fillColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        ground.strokeColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.categoryBitMask = Game.PhysicsCategory.ground
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0
        addChild(ground)
    }
    
    override func update(_ Time: CFTimeInterval) {
        
        if isPause || isGameOver {
            return
        }
        
        // Move the background and obstacles
        
        background1.position = CGPoint(x: background1.position.x - CGFloat(changeInBackground), y: background2.position.y)
        background2.position = CGPoint(x: background1.position.x - CGFloat(changeInBackground), y: background2.position.y)

        // Probably only want to do this for the visible ones, on screen
        for statue in statues {
            statue.position = CGPoint(x: statue.position.x - CGFloat(changeInBackground), y: statue.position.y)
        }
        for rubble in rubbles {
            rubble.position = CGPoint(x: rubble.position.x - CGFloat(changeInBackground), y: rubble.position.y)
        }
        for banana in bananas {
            banana.position = CGPoint(x: banana.position.x - CGFloat(changeInBackground), y: banana.position.y)
        }
        for diamond in diamonds {
            diamond.position = CGPoint(x: diamond.position.x - CGFloat(changeInBackground), y: diamond.position.y)
        }
        for fire in morefire {
            fire.position = CGPoint(x: fire.position.x - CGFloat(changeInBackground), y: fire.position.y)
        }
        
        if (monkey?.position.x)! < CGFloat(0) {
            isGameOver = true
        }
        
        // Repeat the background
        if(background1.position.x - frame.size.width < -background1.size.width) {
            background1.position = CGPoint(x: background2.position.x + background2.size.width - frame.size.width, y: background1.position.y )
        }
        if(background2.position.x - frame.size.width < -background2.size.width) {
            background2.position = CGPoint(x: background1.position.x + background1.size.width - frame.size.width, y: background2.position.y )
        }
        
        // Blow out the fire
        if gameViewController!.audioSession!.recordPermission == AVAudioSession.RecordPermission.granted {
            gameViewController!.recorder.updateMeters()
            
            let level = gameViewController!.recorder.averagePower(forChannel: 0)
            if level > -10 {
                let monkeyPositionX = monkey?.position.x
                if (morefire.count>0) {
                    var nextFire = morefire[0]
                    for fire in morefire.sorted(by: { $0.position.x > $1.position.x }) {
                        if fire.position.x < monkeyPositionX! {
                            // Monkey has already gone past this fire
                            continue
                        }
                        nextFire = fire
                    }
                    if (nextFire.position.x - monkeyPositionX! < 100) {
                        // Can only blow out next fire if close to it
                        removeChildren(in: [nextFire])
                        if let index = morefire.index(of: nextFire) {
                            morefire.remove(at: index)
                        }
                    }
                }
            }
        }

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

