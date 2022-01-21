//
//  SettingsTableViewController.swift
//  sowhat
//
//  Created by a on 1/20/22.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    //: MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    
    //: MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showUser()
    }
    
    //: MARK: TableView Delegates
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0.0 : 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "SettingsToEditProfileSeg", sender: self)
        }
    }

    //: MARK: - IBACTIONS
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        print("tell a friend")
    }
    
    @IBAction func termsAndConditionsButtonPressed(_ sender: Any) {
        print("show t&C")
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        FirebaseUserListner.shared.logOutCurrentUser { error in
            
            if error == nil {
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
                
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
    
    //: MARK: UpdateUI
    private func showUser() {
        
        if let user = User.currentUser {
             
            userNameLabel.text = user.userName
            statusLabel.text = user.status
            appVersionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleshortVersionString"] as? String ?? "")"
            
            if user.avatarLink != "" {
                //download and set avatar
            }
        }
        
    }

}
