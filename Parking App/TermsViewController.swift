//
//  TermsViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/15/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import PMAlertController
import FirebaseDatabase
import Firebase
import FirebaseFirestore


class TermsViewController: UIViewController {
    var Fname = ""
    var Lname = ""
    var email = ""
    var pass = ""

     let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
    }


    @IBAction func Agree(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
       
        
         db.collection("Users").document(uid!).setData(["firstname":self.Fname,"lastname":self.Lname,"Email":self.email,"password":self.pass])
        
        
    }
    
    @IBAction func Disagree(_ sender: Any) {
        let alertVC = PMAlertController(title: "Agreement Required", description: "If you do not agree with how we use your data, we cannot finish creating an account for you.", image: #imageLiteral(resourceName: "your-logo-here"), style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "Dismiss", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "Don't create", style: .default, action: { () in
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
}
