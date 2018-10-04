//
//  SelectAddressViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/25/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import FirebaseFirestore
import Firebase
import Geofirestore
class SelectAddressViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {


   
    
    let uid = Auth.auth().currentUser?.uid
    var lat:CLLocationDegrees?
    var long:CLLocationDegrees?
    let db = Firestore.firestore()
    let marker = GMSMarker()
    var address:String! {
        didSet{
            print(self.address)
        }
    }
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    @IBOutlet weak var MapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            
            
            let position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let marker = GMSMarker(position: position)
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13)
            self.MapView.camera = camera
            self.MapView.animate(toLocation: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            marker.map = self.MapView
            
            
        }

        MapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()

    }


    

    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        plotMarker(AtCoordinate: coordinate, onMapView: mapView)
    }
    
    //MARK: Plot Marker Helper
    private func plotMarker(AtCoordinate coordinate : CLLocationCoordinate2D, onMapView vwMap : GMSMapView) {
        let zoom = self.MapView.camera.zoom
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoom)
        self.marker.position = coordinate
        self.MapView.camera = camera
        marker.map = vwMap
        self.lat = coordinate.latitude
        self.long = coordinate.longitude
    }
    
    @IBAction func DoneButton(_ sender: Any) {
        let geoFirestoreRef = Firestore.firestore().collection("ActiveParkings")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
        geoFirestore.setLocation(location: CLLocation(latitude: lat!, longitude: long!), forDocumentWithID: uid!) { (error) in
            if (error != nil) {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
         _ = self.navigationController?.popViewController(animated: true)
        
    }
    

    

}
