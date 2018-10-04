//
//  MenuViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/15/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore



class MenuViewController: UIViewController {
    
    

    var space1 = false
    
    @IBOutlet weak var manageSpace: UIButton!
    @IBOutlet weak var reciedBookings: UIButton!
    @IBOutlet weak var rentYourspace: UIButton!
    
    
    
    @IBOutlet weak var name: UILabel!
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.space1 == false {
            self.rentYourspace.isHidden = false
            self.reciedBookings.isHidden = true
            self.manageSpace.isHidden = true
        }


        if Auth.auth().currentUser != nil {
            db.collection("Users").document(uid!).getDocument { (snap, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }else{
                    if let document = snap, document.exists {
                            if let Fname = document.data()!["firstname"] as? String {
                                if let lname = document.data()!["lastname"] as? String {
                                    if let space = document.data()!["Space"] as? Bool{
                                        self.space1 = space
                                        
                                        if self.space1 == true {
                                            self.rentYourspace.isHidden = true
                                            self.reciedBookings.isHidden = false
                                            self.manageSpace.isHidden = false
                                        }
                                        self.name.text = "\(Fname)\(lname)"
                                    }
                                    
                                    
                                }
                                
                            }
                        
                    }
                    
                }
            }
        }else{
            print("nothing")
        }

        
    }


    @IBAction func Bookings(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "bookings", sender: self)
        } else {
            self.performSegue(withIdentifier: "log", sender: self)
        }
        
    }

    @IBAction func help(_ sender: Any) {
    }
    @IBAction func rentSapce(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "Rent", sender: self)
        } else {
            self.performSegue(withIdentifier: "log", sender: self)
        }
        
    }
    @IBAction func profile(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "profile", sender: self)
        } else {
             self.performSegue(withIdentifier: "log", sender: self)
        }
        
    }
}


