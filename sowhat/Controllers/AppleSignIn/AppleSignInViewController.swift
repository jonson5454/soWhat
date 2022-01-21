//
//  AppleSignInViewController.swift
//  sowhat
//
//  Created by a on 1/10/22.
//
//  In this controller we verify the user Apple ID and Password
//
//


import UIKit
import ProgressHUD

class AppleSignInViewController: UIViewController, UITextFieldDelegate {

    //: MARK: VIEW
    @IBOutlet weak var otpView: OTPUIView!
    
    //MARK: OUTLETS
    @IBOutlet weak var appleIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var instrunctionsLabel: UILabel!
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var retypeEmailPassButton: UIButton!

    //MARK: PROPERTIES
    
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        //: Add Action on text field
        textFieldAddTarget()
        
        //: Add values in OTPVIew
//        let recordView = OTPUIView(frame: CGRect(x: 20, y: 100, width: 300, height: 0.0))
//        self.view.addSubview(recordView)
//        recordView.otpLabel.text = "Record is showing"
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: ACTIONS
    @IBAction func verifyButtonPressed(_ sender: Any) {
        // here
        if appleIDTextField.text == nil {
            ProgressHUD.showError("Enter Apple ID")
        } else if passwordTextField.text == nil {
            ProgressHUD.showError("Enter password")
        } else {
//            verifyAccount(email: appleIDTextField.text!, password: passwordTextField.text!) { error in
//
//                if error == nil {
//                    ProgressHUD.showError("Error in verification! check email and password then Try Again.")
//                } else {
                    //: Present Alert for OTP
                    self.instrunctionsLabel.text = "Enter Your OTP"
                    
                    //self.verifyButton.setTitle("Submit", for: .normal)
            
            self.otpView.isHidden = false
            otpView.tf1.becomeFirstResponder()
            
            
                    self.passwordTextField.isHidden = true
                    self.appleIDTextField.isHidden = true
                    
                    self.verifyButton.isHidden = true
                    self.rememberMeButton.isHidden = true
                    self.retypeEmailPassButton.isHidden = false
//                }
//
//            }
        }
    }
    
    @IBAction func rememberMeButtonPressed(_ sender: Any) {
        
        
        
    }
    
    @IBAction func retypeEmailPassButtonPressed(_ sender: Any) {
        
        self.verifyButton.setTitle("Verify", for: .normal)

        self.instrunctionsLabel.text = "Manage Your Apple account"
        
        self.passwordTextField.text = ""
        self.passwordTextField.isHidden = false
        self.appleIDTextField.placeholder = "Apple ID"
    }
    
    //MARK: FUNCTIONS
    func verifyAccount(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        //Here Send Cradintials to the apple store
        completion(nil)
    }
    
    //: MARK: OTPVIEW CODE BELOW
    //: Here we put whole the code relate to the OTPView and UITextField
    
    //: MARK: TEXT FIELD ADD DELEGATE
    func textFieldAddDelegate() {
        
        otpView.tf1.delegate = self
        otpView.tf2.delegate = self
        otpView.tf3.delegate = self
        otpView.tf4.delegate = self
        otpView.tf5.delegate = self
        otpView.tf6.delegate = self
        
        
    } //: END: TEXT DELEGATE
    
    //: MARK: TEXT FIELD ADD TARGET
    func textFieldAddTarget() {
        //: Will Understand after this UIView life cycle
        otpView.tf1.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        otpView.tf2.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        otpView.tf3.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        otpView.tf4.addTarget(self, action: #selector(self.textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        otpView.tf5.addTarget(self, action: #selector(textDidChange(_:)), for: UIControl.Event.editingChanged)
        
        otpView.tf6.addTarget(self, action: #selector(textDidChange(_:)), for: UIControl.Event.editingChanged)
    } //: END: ADD TARGET
    
    //: MARK: TEXT CHANGE EVENT
    @objc func textDidChange(_ textField: UITextField) {
        let text = textField.text
        
        if text?.utf16.count == 1 {
            switch textField {
            case otpView.tf1:
                otpView.tf2.becomeFirstResponder()
                break
            case otpView.tf2:
                otpView.tf3.becomeFirstResponder()
                break
            case otpView.tf3:
                otpView.tf4.becomeFirstResponder()
                break
            case otpView.tf4:
                otpView.tf5.becomeFirstResponder()
                break
            case otpView.tf5:
                otpView.tf6.becomeFirstResponder()
            case otpView.tf6:
                otpView.tf6.resignFirstResponder()
            default:
                break
            }
        } else {
            print("Count less then 1")
        }
    } //: END: TEXTCHANGE
    
}
