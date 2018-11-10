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
    
    
    init(screneHeight: Double, screneWidth: Double, ground: Double) {
        self.height = screneHeight
        self.width = screneWidth
        self.groundY = ground
        
        self.monkey = Monkey(height: Double(screneHeight/5),
                             x: screneWidth / 8,
                             y: groundY)
        
        self.bananas = [Banana]()
        self.statues = [Statue]()
        self.rubbles = [Rubble]()

        self.setupStatues(statHeight: (self.monkey?.height)!)
        self.setupBananas(bananaHeight: screneHeight / 15)
        self.setupRubbles(rubbleHeight: (self.monkey?.height)!)
    }
    
    private func setupRubbles (rubbleHeight: Double) {
        
        let rubbleGroundY = groundY + rubbleHeight/2
        rubbles.append(Rubble(height: rubbleHeight,
                              x: (monkey?.startPosX)! + width * 0.6,
                              y: rubbleGroundY))
        
        /*
         rubblePositions.append(CGPoint(x: (monkeyPosition.x) + frameWidth!*2, y: groundPositionY + rubbleHeight))
         */
        
    }
    
    var rubbleHeight : Double? {
        if rubbles.count == 0 { return nil }
        return rubbles[0].height
    }
    
    private func setupBananas (bananaHeight: Double) {
        bananas.append(Banana(height: bananaHeight,
                             x: (monkey?.startPosX)! + width * 0.48,
                             y: groundY + statueHeight! * 4))
        /*
        bananas.append(Banana(height: bananaHeight,
                              x: (monkey?.startPosX)! + width * 2.6,
                              y: groundY + statueHeight! * 5))*/
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
                              x: (monkey?.startPosX)! + width * 0.48,
                              y: statueGroundY + statHeight * 1.3))
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
