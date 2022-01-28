
import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

    //: MARK: IBOUTLETS
    //LABELS
    @IBOutlet weak var emailLabelOutlet: UILabel!
    @IBOutlet weak var passwordLabelOulets: UILabel!
    @IBOutlet weak var repeatPasswordLabelOutlet: UILabel!
    @IBOutlet weak var signUpLabelOutlet: UILabel!
    
    //textFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //Buttons
    @IBOutlet weak var forgotButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var resendButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    //VIEWS
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    
    //: MARK: VERIABLES
    var isLogin = true
    
    //: MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUIFor(login: true)
        setupTextFieldDelegate()
        setupBackgroundTap()
        
//        presentAppleSignInPopup()
    }
    
    //: MARK: IBACTIONS
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "password") {
            //forgot password
            self.resetPassword()
        } else {
            ProgressHUD.showError("Email is required")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.showError("All Fields are required")
        }
    }
    
    @IBAction func resendButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: "register") {
            resetEmail()
        } else {
            ProgressHUD.showError("All Fields are required")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    //: MARK: SETUP
    func setupTextFieldDelegate() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updatePlaceholderLabels(textField: textField)
    }
    
    //: MARK: ANIMATIONS
    
    private func updateUIFor(login: Bool) {

        loginButtonOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButtonOutlet.setTitle(login ? "SignUp" : "Login", for: .normal)

        signUpLabelOutlet.text = login ? "Don't have an account?" : "Have an account?"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabelOutlet.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    private func updatePlaceholderLabels(textField: UITextField) {
        
        switch textField {
            case emailTextField:
                emailLabelOutlet.text = textField.hasText ? "Email" : ""
            case passwordTextField:
                passwordLabelOulets.text = textField.hasText ? "Password" : ""
            default:
                repeatPasswordLabelOutlet.text = textField.hasText ? "Repeat Password" : ""
        }
    }
    
    //: MARK: HIDE KEYBOARD
    private func setupBackgroundTap () {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        view.endEditing(false)
    }
    
    //: MARK: HELPER
    private func isDataInputedFor(type: String) -> Bool {
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "register":
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
    
    //: login user
    func loginUser () {
        
        FirebaseUserListner.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
            
            if error == nil {
                if isEmailVerified {
                    self.goToApp()
                    print("User has been logged in with email: ", User.currentUser?.email)
                } else {
                    ProgressHUD.showError("Email is not verified.")
                    self.resendButtonOutlet.isHidden = false
                }
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
    
    //: register user
    func registerUser() {
        
        if passwordTextField.text == repeatPasswordTextField.text {
            
            FirebaseUserListner.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                
                if error == nil {
                    ProgressHUD.showSuccess("Verification email sent.")
                    self.resendButtonOutlet.isHidden = false
                } else {
                    ProgressHUD.showError(error!.localizedDescription)
                }
            }
        } else {
            ProgressHUD.showError("The Passwords don't match")
        }
    }
    
    //: reset password
    private func resetPassword() {
        
        FirebaseUserListner.shared.resetPasswordFor(email: emailTextField.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("Reset link sent to email.")
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
    
    //: reset email
    private func resetEmail() {
        
        FirebaseUserListner.shared.resendVerificationWith(email: emailTextField.text!) { error in
                
            if error == nil {
                ProgressHUD.showSuccess("New verification email sent")
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
    
    func goToApp() {
        
        let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainApp") as! UITabBarController
        
        main.modalPresentationStyle = .fullScreen
        self.present(main, animated: true, completion: nil)
        
    }
    
    //MARK: APPLE ID VERIFY SCREEN
    func presentAppleSignInPopup() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "appleSignIn") as! UIViewController
        
        storyBoard.modalPresentationStyle = .popover
        self.present(storyBoard, animated: true, completion: nil)
    }
    
    //: MARK: TEMPORARY NAVIGATION
//    func temPoraryNavigation() {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextView") as! NextViewController
//        self.present(nextViewController, animated:true, completion:nil)
//    }

}

