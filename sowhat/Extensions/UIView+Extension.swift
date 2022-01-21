//
//  UIView+Extension.swift
//  sowhat
//
//  Created by a on 1/10/22.
//

import UIKit

//: MARK: PRIVATE PROPERTIES


extension UIView {
    
    @IBInspectable var cornerRedius: CGFloat {
        get { return self.cornerRedius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    
}

