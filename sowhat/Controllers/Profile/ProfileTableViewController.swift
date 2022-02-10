//
//  ProfileTableViewController.swift
//  sowhat
//
//  Created by a on 1/22/22.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //: MARK: IBOUTLETS
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //: MARK: Vars
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        setupUserProfile()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            
            let chatId = startChat(user1: User.currentUser!, user2: user!)
            
            let privateChatView = ChatViewController(chatId: chatId, recipientId: user!.id, recipientName: user!.userName)
            
            privateChatView.hidesBottomBarWhenPushed = true
            
            navigationController?.pushViewController(privateChatView, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }

    func setupUserProfile() {
        if user != nil {
            self.userNameLabel.text = user!.userName
            self.statusLabel.text = user!.status
            self.navigationItem.title = user!.userName
            
            if user!.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user!.avatarLink) { (avatarImage) in
                    
                    self.profileImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
}
