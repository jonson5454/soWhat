//
//  EditProfileTableViewController.swift
//  sowhat
//
//  Created by a on 1/20/22.
//

import UIKit

class EditProfileTableViewController: UITableViewController {

    //: MARK: IBOUTLETS
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    //: MARK: VIEWLIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        showUserInfo()
    }

    //: MARK: TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        
        return headerView
    }

    //: Show User Info
    func showUserInfo() {
        
        if let user = User.currentUser {
            
            userNameTextField.text = user.userName
            statusLabel.text = user.status
            
            if user.avatarLink != ""{
                //set avatar
                
            }
            
        }
        
    }
}
