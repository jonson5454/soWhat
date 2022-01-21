//
//  UIViewController+Extension.swift
//  sowhat
//
//  Created by a on 1/11/22.
//

import UIKit

extension UIViewController {
    
    //: MARK: HIDE KEYBOARD
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundDidTap() {
        view.endEditing(false)
    }
    
    //: MARK: WHEN KEYBOARD APPEARS ADD EXTRA HEIGHT AND REMOVE HEIGHT
    
    
    
    
}
