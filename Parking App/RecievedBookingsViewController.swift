//
//  RecievedBookingsViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/28/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit

class RecievedBookingsViewController: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

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




}
