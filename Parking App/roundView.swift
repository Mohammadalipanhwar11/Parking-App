//
//  roundView.swift
//  Parking App
//
//  Created by Mohammad Ali Panhwar on 9/15/18.
//  Copyright © 2018 Mohammad Ali Panhwar. All rights reserved.
//

import UIKit


@IBDesignable
class roundView: UIImageView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
