//
//  EmailSignUpViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/15/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import PMAlertController

class EmailSignUpViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var name = ""
    var surname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    let uid = Auth.auth().currentUser?.uid

    @IBAction func signUpbutton(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (FirUser, error) in
            if error != nil {
               print(error?.localizedDescription)
                let alertVC = PMAlertController(title: "Error", description: (error?.localizedDescription)!, image: #imageLiteral(resourceName: "your-logo-here"), style: .alert)
                
                alertVC.addAction(PMAlertAction(title: "Dismiss", style: .cancel, action: { () -> Void in
                    print("Capture action Cancel")
                }))
                
                
                self.present(alertVC, animated: true, completion: nil)
               
            }
            
            self.performSegue(withIdentifier: "signUp", sender: self)
        }
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp"{
            let dest = segue.destination as! TermsViewController
            dest.Fname = self.name
            dest.Lname = self.surname
            dest.email = self.email.text!
            dest.pass = self.password.text!
        }
    }

}
