//
//  MapViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/12/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import DateTimePicker
import Geofirestore
import FirebaseFirestore
class MapViewController: UIViewController,CLLocationManagerDelegate,DateTimePickerDelegate {

    

    

    @IBOutlet weak var MainMap: GMSMapView!
    @IBOutlet weak var SearchBarLabel: UITextField!
    @IBOutlet weak var ArrivingLabel: UITextField!
    @IBOutlet weak var LeavingLabel: UITextField!
    @IBOutlet weak var leavingButton: UIButton!
    @IBOutlet weak var arriving: UIButton!
    @IBOutlet weak var MenuButton: UIImageView!
    @IBOutlet weak var menu: UIBarButtonItem!
    

    var cameraLoc:CLLocation?

    var camera = GMSCameraPosition()
    var selected1 = false
    var adres:String! {
        didSet{
            print(self.adres)
        }
    }
    var Selected:Bool? = nil
    
    var locationManager = CLLocationManager()
    let marker = GMSMarker()
     let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBarLabel.text = adres
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()

        
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if Selected == true {
        geoCoder.geocodeAddressString(adres) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            
            
            let position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let marker = GMSMarker(position: position)
            
            self.cameraLoc = location
            
            
            if self.selected1 == true{
                
                self.MainMap.animate(toLocation: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                marker.map = self.MainMap
                self.selected1 = false
            }
            
            
            let geoFirestoreRef = Firestore.firestore().collection("ActiveParkings")
            let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
            let geo = geoFirestore.query(withCenter: location, radius: 100)
            geo.observe(.documentEntered, with: { (key, location) in
                let Marker = GMSMarker()
                Marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "parking-sign"), scaledToSize: CGSize(width: 40, height: 40))
                Marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                Marker.map = self.MainMap

                
            })
            
            }
            
        }
    }


        @IBAction func searchBar(_ sender: Any) {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            
            present(autocompleteController, animated: true, completion: nil)
           
    
    }
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    


    @IBAction func ArrivingButton(_ sender: Any) {
    
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "DONE"
        picker.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            self.ArrivingLabel.text = formatter.string(from: date)
        }
        picker.delegate = self
            picker.show()
            
        
       

    }
    
    @IBAction func leaving(_ sender: Any) {
        
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker1 = DateTimePicker.create(minimumDate: min, maximumDate: max)
        picker1.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker1.darkColor = UIColor.darkGray
        picker1.doneButtonTitle = "Done"
        picker1.doneBackgroundColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker1.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            self.LeavingLabel.text = formatter.string(from: date)
        }
        picker1.delegate = self
            picker1.show()
            
        
    }
    

    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        
        if leavingButton.isSelected == true {
            self.LeavingLabel.text = picker.selectedDateString
            
        }else if arriving.isSelected == true{
            self.ArrivingLabel.text = picker.selectedDateString
        }
    }

  
    

}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.Selected = true
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        self.SearchBarLabel.text = place.formattedAddress
        self.adres = place.formattedAddress!
        selected1 = true
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

    
}

