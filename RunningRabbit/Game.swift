//
//  Game.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 09/11/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation

class Game {
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let monkey    : UInt32 = 1
        static let statue    : UInt32 = 2
        static let diamond   : UInt32 = 3
        static let ground    : UInt32 = 4
        static let rubble    : UInt32 = 5
        static let banana    : UInt32 = 6
        static let fire      : UInt32 = 7
    }
    
    // Couldn't use enum because values might not be unique
    struct Layout {
        static let fireOnGroundY : Double = 35
        static let rubbleOnGroundY : Double = 10
        static let statueOnGroundY : Double = 40
        static let statueOnFirstY : Double = 120
        static let statueOnSecondY : Double = 180
        static let bananaOffsetY : Double = 70
        static let diamondOffsetY : Double = 120
        
        static let block1X : Double = 300
        static let block2X : Double = 410
        static let block3X : Double = 520
        static let block4X : Double = 600
        static let block5X : Double = 700
        static let block6X : Double = 710
        static let block7X : Double = 770
        static let block8X : Double = 830
        static let block9X : Double = 1000
        static let block10X : Double = 1100
        static let block11X : Double = 1150
        static let block12X : Double = 1200
        static let block13X : Double = 1400
        static let block14X : Double = 1450
        static let block15X : Double = 1555
        static let block16X : Double = 1610
        static let block17X : Double = 1750
        static let block18X : Double = 1950
        static let block19X : Double = 1970
        static let block20X : Double = 2000
        static let block21X : Double = 2030
        static let block22X : Double = 2060
        static let block23X : Double = 2090
        static let block24X : Double = 3020
        static let block25X : Double = 3050
        static let block26X : Double = 3080
        static let block27X : Double = 3110
        static let block28X : Double = 3140
        static let block29X : Double = 3200
        static let block30X : Double = 3300
    }
    
    var height : Double
    var width : Double
    var groundY : Double

    var monkey : Monkey?
    var bananas : [Banana]
    var statues : [Statue]
    var rubbles : [Rubble]
    var diamonds : [Diamond]
    var morefire : [Fire]
    
    var highScoreCount : Int
    
    
    init(screneHeight: Double, screneWidth: Double, ground: Double) {
        self.height = screneHeight
        self.width = screneWidth
        self.groundY = ground
        self.highScoreCount = 10
        
        self.monkey = Monkey(height: Double(screneHeight/5),
                             x: screneWidth / 8,
                             y: groundY + (screneHeight/5)/2)
        
        self.bananas = [Banana]()
        self.statues = [Statue]()
        self.rubbles = [Rubble]()
        self.diamonds = [Diamond]()
        self.morefire = [Fire]()

        
        self.setupStatues(statHeight: (self.monkey?.height)!)
        self.setupBananas(bananaHeight: screneHeight / 15)
        self.setupRubbles(rubbleHeight: (self.monkey?.height)!/3)
        self.setupDiamonds(diamondHeight: (self.monkey?.height)!/3) //maybe change
        self.setupFire(fireHeight: (self.monkey?.height)!/3) //maybe change
 
    }

    private func setupFire (fireHeight: Double) {
        let fireGroundY = groundY + Layout.fireOnGroundY
        morefire.append(Fire(height: fireHeight, x: Layout.block3X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block10X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block12X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block17X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block19X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block20X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block21X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block22X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block23X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block24X, y: fireGroundY))
        morefire.append(Fire(height: fireHeight, x: Layout.block25X, y: fireGroundY))
    }
    
    var fireHeight : Double? {
        if morefire.count == 0 { return nil }
        return morefire[0].height
    }
    
    private func setupDiamonds (diamondHeight: Double) {
        
        let diamondGroundY = groundY + Layout.diamondOffsetY
        diamonds.append(Diamond(height: diamondHeight, x: Layout.block11X, y: diamondGroundY, isFinal: false))
        diamonds.append(Diamond(height: diamondHeight, x: Layout.block16X, y: diamondGroundY, isFinal: false))
        diamonds.append(Diamond(height: diamondHeight, x: Layout.block29X, y: diamondGroundY, isFinal: true))
    }
    
    var diamondHeight : Double? {
        if diamonds.count == 0 { return nil }
        return diamonds[0].height
    }
    
    private func setupRubbles (rubbleHeight: Double) {
        let rubbleGroundY = groundY + Layout.rubbleOnGroundY
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block3X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block10X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block12X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block17X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block19X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block20X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block21X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block22X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block23X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block24X, y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight, x: Layout.block25X, y: rubbleGroundY))
    }
    
    var rubbleHeight : Double? {
        if rubbles.count == 0 { return nil }
        return rubbles[0].height
    }
    
    private func setupBananas (bananaHeight: Double) {
        let ground = groundY + Layout.statueOnGroundY + Layout.bananaOffsetY
        let first = groundY + Layout.statueOnFirstY + Layout.bananaOffsetY
        let second = groundY + Layout.statueOnSecondY + Layout.bananaOffsetY
        
        bananas.append(Banana(height: bananaHeight, x: Layout.block1X, y: ground))
        bananas.append(Banana(height: bananaHeight, x: Layout.block2X, y: first))
        bananas.append(Banana(height: bananaHeight, x: Layout.block7X, y: first))
        bananas.append(Banana(height: bananaHeight, x: Layout.block8X, y: first))
        bananas.append(Banana(height: bananaHeight, x: Layout.block14X, y: first))
        bananas.append(Banana(height: bananaHeight, x: Layout.block16X, y: second))
        bananas.append(Banana(height: bananaHeight, x: Layout.block20X, y: ground))
        bananas.append(Banana(height: bananaHeight, x: Layout.block22X, y: ground))
        bananas.append(Banana(height: bananaHeight, x: Layout.block27X, y: ground))



    }
    
    var bananaHeight : Double? {
        if bananas.count == 0 { return nil }
        return bananas[0].height
    }
    
    private func setupStatues (statHeight: Double) {
        
        let statueGroundY = groundY + Layout.statueOnGroundY
        let statueFirstY = groundY + Layout.statueOnFirstY
        let statueSecondY = groundY + Layout.statueOnSecondY
        statues.append(Statue(height: statHeight, x: Layout.block1X, y: statueGroundY))
        statues.append(Statue(height: statHeight, x: Layout.block2X, y: statueFirstY))
        statues.append(Statue(height: statHeight, x: Layout.block5X, y: statueGroundY))
        statues.append(Statue(height: statHeight, x: Layout.block7X, y: statueFirstY))
        statues.append(Statue(height: statHeight, x: Layout.block8X, y: statueFirstY))
        statues.append(Statue(height: statHeight, x: Layout.block11X, y: statueGroundY))
        statues.append(Statue(height: statHeight, x: Layout.block13X, y: statueGroundY))
        statues.append(Statue(height: statHeight, x: Layout.block14X, y: statueFirstY))
        statues.append(Statue(height: statHeight, x: Layout.block15X, y: statueSecondY))
        
    }
    
    var statueHeight : Double? {
        if statues.count == 0 { return nil }
        return statues[0].height
    }
    
    /*
 statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*0.8, y: groundPositionY + statueHeight))
 statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*1.2, y: groundPositionY + statueHeight))
 statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*1.3, y: groundPositionY + 1.5*statueHeight))
 statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*1.4, y: groundPositionY + 2*statueHeight))
 statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*1.5, y: groundPositionY + 1.5*statueHeight))
 statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*2.5, y: groundPositionY + statueHeight))
 statuePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*2.6, y: groundPositionY + 1.5*statueHeight))
 
 */
    
    
    
    
    
}
