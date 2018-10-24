//
//  HighscoreViewController.swift
//  RunningRabbit
//
//  Created by María Karlsdóttir on 11/10/2018.
//  Copyright © 2018 María Karlsdóttir. All rights reserved.
//

import Foundation
import UIKit

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Temporary, will later fetch from database
    var highScores = [
        HighScore(score: 100, name: "Player 1"),
        HighScore(score: 95, name: "Player 2"),
        HighScore(score: 87, name: "Player 3"),
        HighScore(score: 67, name: "Player 4"),
        HighScore(score: 44, name: "Player 5"),
        HighScore(score: 34, name: "Player 6"),
        HighScore(score: 33, name: "Player 7"),
        HighScore(score: 30, name: "Player 8"),
        HighScore(score: 29, name: "Player 9"),
        HighScore(score: 10, name: "Player 10"),
        HighScore(score: 9, name: "Player 11"),
        HighScore(score: 8, name: "Player 12"),
        HighScore(score: 7, name: "Player 13")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // https://pusher.com/tutorials/realtime-table-swift/
        
    }
    
    @IBOutlet weak var highScoreTableView: UITableView! {
        didSet {
            highScoreTableView.dataSource = self
            highScoreTableView.delegate = self
        }
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = String(highScores[indexPath.row].score)
        cell.detailTextLabel?.text = highScores[indexPath.row].name
        
        return cell
    }
 

}
