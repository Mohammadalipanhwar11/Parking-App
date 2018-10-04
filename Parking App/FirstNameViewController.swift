//
//  FirstNameViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/15/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class FirstNameViewController: UIViewController {

    var ref: DatabaseReference!
    
    
    
    @IBOutlet weak var fisrtname: UITextField!
    @IBOutlet weak var next1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      ref = Database.database().reference()

        
        
    }

    @IBAction func nextbutton(_ sender: Any) {
        performSegue(withIdentifier: "surname", sender: self.fisrtname.text)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "surname"{
            let dest = segue.destination as! lastNameViewController
            dest.firstname = self.fisrtname.text!
        }
    }
    

}
