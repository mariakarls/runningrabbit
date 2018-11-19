//
//  GameOverViewController.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 19/11/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import UIKit
import Foundation

class GameOverViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    var currentScore = 0
    
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentScore = userDefaults.integer(forKey: DefaultKeys.currentPlayerScore.rawValue)
        scoreTextField.text = String(currentScore)
        scoreTextField.isUserInteractionEnabled = false
    }
    
    @IBAction func saveHighScore(_ sender: UIButton) {
        let decoded = userDefaults.object(forKey: DefaultKeys.highScoreList.rawValue) as! Data
        let highScores = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Array<HighScore>
        var sortedHighScoreList = highScores.sorted(by: { $0.score > $1.score })
        let newHighScore = HighScore(score: currentScore, name: nameTextField.text!)

        if newHighScore.score > sortedHighScoreList[9].score {
            sortedHighScoreList[9] = newHighScore
        }
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: sortedHighScoreList)
        userDefaults.set(encodedData, forKey: DefaultKeys.highScoreList.rawValue)
        
        performSegue(withIdentifier: "showHighScoreController", sender: nil)
    }

}
