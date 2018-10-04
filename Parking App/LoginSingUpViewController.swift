//
//  LoginSingUpViewController.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/11/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import GooglePlacePicker

class LoginSingUpViewController: UIViewController {

   
    @IBOutlet weak var facebookLogin: FBSDKLoginButton!
    @IBOutlet weak var googleLogin: GIDSignInButton!
    @IBOutlet weak var EmailOrPhoneSignIn: UIButton!
    @IBOutlet weak var SignUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        EmailOrPhoneSignIn.layer.borderWidth = 1/UIScreen.main.nativeScale
        EmailOrPhoneSignIn.layer.borderColor = UIColor.white.cgColor
        
        SignUp.layer.borderWidth = 1/UIScreen.main.nativeScale
        SignUp.layer.borderColor = UIColor.white.cgColor


    }

    @IBAction func LoginButton(_ sender: Any) {
        
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}




















extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}







