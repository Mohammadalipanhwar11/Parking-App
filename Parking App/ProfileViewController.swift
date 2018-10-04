//
//  ProfileViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/24/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import FirebaseFirestore
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var Fname: UILabel!
    @IBOutlet weak var Lname: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("Users").document(uid!).getDocument { (snap, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if let document = snap, document.exists {
                    if let dataDescription = document.data()!["Email"] as? String {
                        if let Fname = document.data()!["firstname"] as? String {
                            if let lname = document.data()!["lastname"] as? String {
                                self.email.text = dataDescription
                                self.Fname.text = Fname
                                self.Lname.text = lname
                                self.titleName.text = Fname
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
            }
            
        }
        sideMenus()
    }
    func sideMenus(){
        if revealViewController() != nil {
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }

    @IBAction func RentaSpace(_ sender: Any) {
    }
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "logout", sender:self)
        }catch let signOutError as NSError {
            print(signOutError)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainView"{
            if let adpostVC = segue.destination as? ViewController {
                let popPC = adpostVC.popoverPresentationController
                popPC?.delegate = self
        }
    }
    

    }
    
}
extension ProfileViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
    }
    

