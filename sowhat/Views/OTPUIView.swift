//
//  OTPUIView.swift
//  sowhat
//
//  Created by a on 1/12/22.
//
//  In this class we are setting the cutom view for OTP screen to get and print the OTP View to the Customer
//

import UIKit

class OTPUIView: UIView {

    //: MARK: IBOUTLETS
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var tf5: UITextField!
    @IBOutlet weak var tf6: UITextField!
    
    //: MARK: PROPERTIES
    static let shared = OTPUIView()
    
    //: MARK: INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    //: MARK: CODER
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commontInit()
    }
    
    //: MARK: COMMON INIT TO ATTACH VIEW
    func commontInit() {
        let viewFromXib = Bundle.main.loadNibNamed("OTPUIView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        
        //: Borders Function
        self.addBorders()
    }
    
    //: MARK: TEXT FIELD ADD DELEGATE
    func textFieldAddDelegate(_ delegate: AppleSignInViewController) {
        
        tf1.delegate =  delegate
        tf2.delegate = delegate
        tf3.delegate = delegate
        tf4.delegate = delegate
        tf5.delegate = delegate
        tf6.delegate = delegate
        
        //: Text Field 1 becomeFirstResponder
        tf1.becomeFirstResponder()
        
        //: Add Action on text field
        textFieldAddTarget()
        
    } //: END: TEXT DELEGATE
    
    //: MARK: TEXT FIELD ADD TARGET
    func textFieldAddTarget() {
        //: Will Understand after this UIView life cycle
        tf1.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        tf2.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        tf3.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        tf4.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        tf5.addTarget(self, action: #selector(textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        tf6.addTarget(self, action: #selector(textDidChange(_:)), for: UIControl.Event.editingChanged)
    } //: END: ADD TARGET
    
    //: MARK: TEXT CHANGE EVENT
    @objc func textDidChange(_ textField: UITextField) {
        let text = textField.text
        
        if text?.utf16.count == 1 {
            switch textField {
            case tf1:
                tf2.becomeFirstResponder()
                break
            case tf2:
                tf3.becomeFirstResponder()
                break
            case tf3:
                tf4.becomeFirstResponder()
                break
            case tf4:
                tf5.becomeFirstResponder()
                break
            case tf5:
                tf6.becomeFirstResponder()
            default:
                break
            }
        } else {
            print("Count less then 1")
        }
    } //: END: TEXTCHANGE
    
    //: MARK: ADD BORDERS
    func addBorders() {
        tf1.addBottomBorder()
        tf2.addBottomBorder()
        tf3.addBottomBorder()
        tf4.addBottomBorder()
        tf5.addBottomBorder()
        tf6.addBottomBorder()
        
        
    } //: END: BORDER
    
}
