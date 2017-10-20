//
//  PickUpCell.swift
//  
//
//  Created by Prateek Mahawar on 20/10/17.
//

import UIKit

class PickUpLineCell: UITableViewCell {
    
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func configure(with pickUpLine: PickUpLine) {
        lineLabel.text = pickUpLine.line
        scoreLabel.text = pickUpLine.scoreString()
        emailLabel.text = pickUpLine.email
    }
    
}

