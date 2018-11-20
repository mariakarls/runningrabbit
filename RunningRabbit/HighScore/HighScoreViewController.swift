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
    var highScores = Array<HighScore>()
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScores = HighScore.getData(from: userDefaults)!
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
