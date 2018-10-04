//
//  lastNameViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/15/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit

class lastNameViewController: UIViewController {

    @IBOutlet weak var surname1: UITextField!
    @IBOutlet weak var next1: UIButton!
    var firstname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "email", sender: surname1.text)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "email"{
            let dest = segue.destination as! EmailSignUpViewController
            dest.surname = self.surname1.text!
             dest.name = self.firstname
        }
    }
    

}
