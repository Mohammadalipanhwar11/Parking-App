//
//  EmailSignInViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/15/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import Firebase
import PMAlertController
class EmailSignInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }


    @IBAction func LoginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                let alertVC = PMAlertController(title: "Error", description: (error?.localizedDescription)!, image: #imageLiteral(resourceName: "your-logo-here"), style: .alert)
                
                alertVC.addAction(PMAlertAction(title: "Dismiss", style: .cancel, action: { () -> Void in
                    print("Capture action Cancel")
                }))
                
                
                self.present(alertVC, animated: true, completion: nil)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
