//
//  EditTableViewController.swift
//  
//
//  Created by Mohammad Ali Panhwar on 10/2/18.
//

import UIKit
import GoogleMaps
import FirebaseFirestore
import Firebase
import Geofirestore
import PMAlertController
class EditTableViewController: UITableViewController {

    
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var Country: UILabel!
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var MapView: GMSMapView!
    @IBOutlet weak var SpaceType: UISegmentedControl!
    @IBOutlet weak var numberOfSpaces: UITextField!
    @IBOutlet weak var OwnerType: UISegmentedControl!
    @IBOutlet weak var WidthSpace: UISegmentedControl!
    @IBOutlet weak var PricePerHour: UITextField!
    @IBOutlet weak var PricePerDay: UITextField!
    @IBOutlet weak var PricePerWeek: UITextField!
    
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        
        let geoFirestoreRef = Firestore.firestore().collection("ActiveParkings")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)

        geoFirestore.getLocation(forDocumentWithID: uid!) { (location: CLLocation?, error) in
            if (error != nil) {
                print("An error occurred: \(error)")
            } else if (location != nil) {
                print("Location: [\(location!.coordinate.latitude), \(location!.coordinate.longitude)]")
                let marker = GMSMarker()
                marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "parking-sign"), scaledToSize: CGSize(width: 40, height: 40))
                marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                marker.map = self.MapView
                
                let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13)
                self.MapView.camera = camera
            } else {
                print("GeoFirestore does not contain a location for this document")
            }
        }
        

        sideMenus()
        db.collection("Users").document(uid!).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let spaceType = document.data()!["SpaceType"] as! String
                let ownerType = document.data()!["OwnerType"] as! String
                let spacewidth = document.data()!["SpaceWidth"] as! String
                let numberofSpaces = document.data()!["numberofSpaces"] as! String
                let address = document.data()!["Adrress"] as! String
                if let pricePerhour = document.data()!["pricePerHour"] as? String{
                    if let pricePerday = document.data()!["pricePerDay"] as? String{
                        if let pricePerweek = document.data()!["pricePerWeek"] as? String{
                            self.PricePerHour.text = pricePerhour
                            self.PricePerDay.text = pricePerday
                            self.PricePerWeek.text = pricePerweek
                        }
                    }
                }
                
                
                
                if spaceType == "Driveway" {
                    self.SpaceType.selectedSegmentIndex = 0
                }else if spaceType == "Garage"{
                    self.SpaceType.selectedSegmentIndex = 1
                }else if spaceType == "CarPark"{
                    self.SpaceType.selectedSegmentIndex = 2
                }
                if spacewidth == "Normal" {
                    self.WidthSpace.selectedSegmentIndex = 0
                }else if spacewidth == "Narrow"{
                    self.WidthSpace.selectedSegmentIndex = 1
                }
                if ownerType == "Individual" {
                    self.OwnerType.selectedSegmentIndex = 0
                }else if ownerType == "Business"{
                    self.OwnerType.selectedSegmentIndex = 1
                }
                self.numberOfSpaces.text = numberofSpaces
                self.Country.text = address
            } else {
                print("Document does not exist")
            }
        }

    }
    func sideMenus(){
        if revealViewController() != nil {
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
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
    @IBAction func TypeofSpaceButton(_ sender: UISegmentedControl) {
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
    @IBAction func widthSpaceButton(_ sender: UISegmentedControl) {
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
    
    @IBAction func OwnerType(_ sender: UISegmentedControl) {
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
    @IBAction func SaveButton(_ sender: Any) {
        if self.numberOfSpaces.text != "" && self.PricePerHour.text != "" && self.PricePerDay.text != "" && self.PricePerWeek.text != "" {
            db.collection("Users").document(uid!).updateData(["numberofSpaces":self.numberOfSpaces.text!])
            db.collection("Users").document(uid!).updateData(["pricePerHour":self.PricePerHour.text!])
            db.collection("Users").document(uid!).updateData(["pricePerDay":self.PricePerDay.text!])
            db.collection("Users").document(uid!).updateData(["pricePerWeek":self.PricePerWeek.text!])
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            let alertVC = PMAlertController(title: "Something Empty", description: "Recheck all the fields and try again.", image: #imageLiteral(resourceName: "your-logo-here"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Dismiss", style: .cancel, action: { () -> Void in
                print("Capture action Cancel")
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
        
        
        
    }
    
    



}
