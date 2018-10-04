//
//  RentSpaceTableViewController.swift
//  
//
//  Created by Mohammad Ali Panhwar on 9/25/18.
//

import UIKit
import GoogleMaps
import SVProgressHUD
import GooglePlaces
import CountryPickerView
import FirebaseFirestore
import Firebase
import PMAlertController
class RentSpaceTableViewController: UITableViewController {

    
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    var adress = ""
    let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    
    @IBOutlet weak var selectCountry: UITextField!
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var selectAddress: UITextField!
    @IBOutlet weak var SpaceType: UISegmentedControl!
    @IBOutlet weak var numberOfSpaces: UITextField!
    @IBOutlet weak var OwnerType: UISegmentedControl!
    @IBOutlet weak var SpaceWidth: UISegmentedControl!
    @IBOutlet weak var Fname: UITextField!
    @IBOutlet weak var Lname: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.SpaceType.selectedSegmentIndex = UISegmentedControlNoSegment
        self.OwnerType.selectedSegmentIndex = UISegmentedControlNoSegment
        self.SpaceWidth.selectedSegmentIndex = UISegmentedControlNoSegment
        
        PhoneNumber.leftView = cp
        PhoneNumber.leftViewMode = .always
        sideMenus()
        self.tableView.allowsSelection = false
    }


    func sideMenus(){
        if revealViewController() != nil {
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    

    @IBAction func rentSpace(_ sender: Any) {
        if self.PhoneNumber.text != "" && self.Fname.text != "" && self.Lname.text != "" && self.numberOfSpaces.text != "" && self.selectCountry.text != ""{
            db.collection("Users").document(uid!).updateData(["Phone":self.PhoneNumber.text!])
            db.collection("Users").document(uid!).updateData(["firstname":self.Fname.text!])
            db.collection("Users").document(uid!).updateData(["lastname":self.Lname.text!])
            db.collection("Users").document(uid!).updateData(["numberofSpaces":self.numberOfSpaces.text!])
            db.collection("Users").document(uid!).updateData(["Adrress":self.selectCountry.text!])
            db.collection("Users").document(uid!).updateData(["Space":true])
            self.performSegue(withIdentifier: "parking", sender: self)
        }else{
            let alertVC = PMAlertController(title: "Fields are Empty", description: "Please check if any field is not empty ", image: #imageLiteral(resourceName: "your-logo-here"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Dismiss", style: .cancel, action: { () -> Void in
                print("Capture action Cancel")
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    
    @IBAction func country(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func findAddress(_ sender: Any) {
        performSegue(withIdentifier: "Map2", sender: self)
    }
    
    @IBAction func SpaceTypeButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            db.collection("Users").document(uid!).updateData(["SpaceType":"Driveway"])
            print("1")
        case 1:
            db.collection("Users").document(uid!).updateData(["SpaceType":"Garage"])
            print("2")
        case 2:
            db.collection("Users").document(uid!).updateData(["SpaceType":"CarPark"])
            print("3")
        default:
            break
        }
    }
    @IBAction func OwnerTypeButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            db.collection("Users").document(uid!).updateData(["OwnerType":"Individual"])
            print("1")
        case 1:
            db.collection("Users").document(uid!).updateData(["OwnerType":"Business"])
            print("2")
        
        default:
            break
        }
        
    }
    @IBAction func SpaceWidthButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            db.collection("Users").document(uid!).updateData(["SpaceWidth":"Normal"])
            print("1")
        case 1:
            db.collection("Users").document(uid!).updateData(["SpaceWidth":"Narrow"])
            print("2")
        default:
            break
        }
    }
    
    



}
extension RentSpaceTableViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            print("Place name: \(place.name)")
            
            print("Place address: \(String(describing: place.formattedAddress))")
            self.selectCountry.text = place.formattedAddress!
            self.adress = place.formattedAddress!
        
            print("Place attributions: \(String(describing: place.attributions))")
            
                self.dismiss(animated: true, completion: nil)
                
            
        
        
        
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
        if segue.identifier == "Map2" {
            let dest = segue.destination as! SelectAddressViewController
            dest.address = self.adress
        }
    }

    
}

