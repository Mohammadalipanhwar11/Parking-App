//
//  ManagespaceTableViewCell.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/29/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit

class ManagespaceTableViewCell: UITableViewCell {


    @IBOutlet weak var Edit: UIButton!
    @IBOutlet weak var Active: UIButton!
    @IBOutlet weak var prices: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var Space3: UILabel!
    @IBOutlet weak var space2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func activateButton(_ sender: Any) {
    }
    @IBAction func EditButton(_ sender: Any) {
        
    }
    @IBAction func Availibility(_ sender: Any) {
    }
    @IBAction func Photos(_ sender: Any) {
    }
    @IBAction func instantbookingsbutton(_ sender: Any) {
    }
    
    
}
