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
    }
    
    var height : Double
    var width : Double
    var groundY : Double

    var monkey : Monkey?
    var bananas : [Banana]
    var statues : [Statue]
    var rubbles : [Rubble]
    var diamonds : [Diamond]
    
    
    init(screneHeight: Double, screneWidth: Double, ground: Double) {
        self.height = screneHeight
        self.width = screneWidth
        self.groundY = ground
        
        self.monkey = Monkey(height: Double(screneHeight/5),
                             x: screneWidth / 8,
                             y: groundY + (screneHeight/5)/2)
        
        self.bananas = [Banana]()
        self.statues = [Statue]()
        self.rubbles = [Rubble]()
        self.diamonds = [Diamond]()

        self.setupStatues(statHeight: (self.monkey?.height)!)
        self.setupBananas(bananaHeight: screneHeight / 15)
        self.setupRubbles(rubbleHeight: (self.monkey?.height)!/3)
        self.setupDiamonds(diamondHeight: (self.monkey?.height)!/3) //skal muligvis rettes
    }
    
    private func setupDiamonds (diamondHeight: Double) {
        
        let diamondGroundY = groundY + diamondHeight/2
        diamonds.append(Diamond(height: diamondHeight,
                              x: (monkey?.startPosX)! + width * 2.2,
                              y: diamondGroundY + statueHeight!))
    }
    
    var diamondHeight : Double? {
        if diamonds.count == 0 { return nil }
        return diamonds[0].height
    }
    
    private func setupRubbles (rubbleHeight: Double) {
        
        let rubbleGroundY = groundY + rubbleHeight/2
        rubbles.append(Rubble(height: rubbleHeight,
                              x: (monkey?.startPosX)! + width * 0.5,
                              y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight,
                              x: (monkey?.startPosX)! + width * 1.2,
                              y: rubbleGroundY))
        rubbles.append(Rubble(height: rubbleHeight,
                              x: (monkey?.startPosX)! + width * 1.35,
                              y: rubbleGroundY))
        
    }
    
    var rubbleHeight : Double? {
        if rubbles.count == 0 { return nil }
        return rubbles[0].height
    }
    
    private func setupBananas (bananaHeight: Double) {
        bananas.append(Banana(height: bananaHeight,
                              x: (monkey?.startPosX)! + 100,
                              y: groundY + (monkey?.height)!))
        bananas.append(Banana(height: bananaHeight,
                             x: (monkey?.startPosX)! + width * 0.3,
                             y: groundY + statueHeight! * 2))
        bananas.append(Banana(height: bananaHeight,
                              x: (monkey?.startPosX)! + width * 0.75,
                              y: groundY + statueHeight! * 2))
        bananas.append(Banana(height: bananaHeight,
                              x: (monkey?.startPosX)! + width * 0.9,
                              y: groundY + statueHeight! * 3))
        bananas.append(Banana(height: bananaHeight,
                              x: (monkey?.startPosX)! + width * 1,
                              y: groundY + statueHeight! * 3))
        bananas.append(Banana(height: bananaHeight,
                              x: (monkey?.startPosX)! + width * 1,
                              y: groundY + statueHeight! * 3.5))
        bananas.append(Banana(height: bananaHeight,
                              x: (monkey?.startPosX)! + width * 1.7,
                              y: groundY + statueHeight! * 3))
        bananas.append(Banana(height: bananaHeight,
                              x: (monkey?.startPosX)! + width * 1.78,
                              y: groundY + statueHeight! * 3))

    }
    
    var bananaHeight : Double? {
        if bananas.count == 0 { return nil }
        return bananas[0].height
    }
    
    private func setupStatues (statHeight: Double) {
        
        let statueGroundY = groundY + statHeight/2
        statues.append(Statue(height: statHeight,
                              x: (monkey?.startPosX)! + width * 0.2,
                              y: statueGroundY))
        statues.append(Statue(height: statHeight,
                              x: (monkey?.startPosX)! + width * 0.3,
                              y: statueGroundY + statHeight * 0.5))
        statues.append(Statue(height: statHeight,
                              x: (monkey?.startPosX)! + width * 0.75,
                              y: statueGroundY))
        statues.append(Statue(height: statHeight,
                              x: (monkey?.startPosX)! + width * 0.9,
                              y: statueGroundY + statHeight * 1))
        statues.append(Statue(height: statHeight,
                              x: (monkey?.startPosX)! + width * 1,
                              y: statueGroundY + statHeight * 1))
        statues.append(Statue(height: statHeight,
                              x: (monkey?.startPosX)! + width * 1.28,
                              y: statueGroundY))
        statues.append(Statue(height: statHeight,
                              x: (monkey?.startPosX)! + width * 1.7,
                              y: statueGroundY + statHeight * 1))
        statues.append(Statue(height: statHeight,
                              x: (monkey?.startPosX)! + width * 1.78,
                              y: statueGroundY + statHeight * 1))
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
