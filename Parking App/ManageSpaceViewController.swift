//
//  ManageSpaceViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/28/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SVProgressHUD
struct Parkings {
    var ownerType:String
    var Phone:String
    var spaceType:String
    var SpaceWidth:String
    var numberOfspaces:String
    var price:String
}

var arr:[Parkings] = []
class ManageSpaceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    var price1 = "18"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.allowsSelection = false
        
        SVProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            self.db.collection("Users").document(self.uid!).getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    let spaceType = document.data()!["SpaceType"] as! String
                    let ownerType = document.data()!["OwnerType"] as! String
                    let spacewidth = document.data()!["SpaceWidth"] as! String
                    let phone = document.data()!["Phone"] as! String
                    let numberofSpaces = document.data()!["numberofSpaces"] as! String
                    
                    if let price = document.data()!["pricePerHour"] as? String {
                        self.price1 = price
                    }
                    let ar = Parkings(ownerType: ownerType, Phone: phone, spaceType: spaceType, SpaceWidth: spacewidth, numberOfspaces: numberofSpaces, price: self.price1)
                    arr.append(ar)
                    
                    self.tableView.reloadData()
                    
                    print(spaceType)
                } else {
                    print("Document does not exist")
                }
            }
            DispatchQueue.main.async {

                SVProgressHUD.dismiss()
            }
        }
        


        tableView.dataSource = self
        tableView.delegate = self
        sideMenus()
        
    }


    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! ManagespaceTableViewCell
        cell.Space3.text = "\(arr[indexPath.row].ownerType) \(arr[indexPath.row].spaceType) - (\(arr[indexPath.row].numberOfspaces) space"
        cell.Space3.sizeToFit()
        cell.Edit.tag = indexPath.row
        cell.Edit.addTarget(self, action: #selector(ManageSpaceViewController.segue(_sender:)), for: UIControlEvents.touchUpInside)
        cell.prices.text = arr[indexPath.row].price
        arr.removeAll()
        return cell
    }

    @objc func segue(_sender:UIButton){
        performSegue(withIdentifier: "edit", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    func sideMenus(){
        if revealViewController() != nil {
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    @IBAction func AddanotherSpace(_ sender: Any) {
        
    }
    

}
