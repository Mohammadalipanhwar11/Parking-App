//
//  ViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/11/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import GooglePlacePicker
import SVProgressHUD
import Firebase
class ViewController: UIViewController {
   
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var menu: UIBarButtonItem!
    var address = ""
    var selected:Bool?

    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            signInButton.isHidden = true
        } else {
            signInButton.isHidden = false
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



}

extension ViewController: GMSAutocompleteViewControllerDelegate {

    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        SVProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            print("Place name: \(place.name)")
            
            print("Place address: \(String(describing: place.formattedAddress))")
            self.address = place.formattedAddress!
            self.selected = true
            print("Place attributions: \(String(describing: place.attributions))")
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "Map1", sender: nil)
                SVProgressHUD.dismiss()
            }
        }

        
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
   

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Map1" {
            let dest = segue.destination as! MapViewController
            dest.adres = self.address
            dest.Selected = self.selected
            dest.selected1 = true
        }
    }

}




