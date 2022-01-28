//
//  UserTableViewCell.swift
//  sowhat
//
//  Created by a on 1/22/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //: MARK: IBOUTLETS
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    //: MARK: VARS
    
    //: MARK: CELL LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func configure(user: User) {
        
        userNameLabel.text = user.userName
        statusLabel.text = user.status
        self.setAvatar(user.avatarLink)
    }
    
    private func setAvatar(_ avatarLink: String) {
        
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
                self.avatarImageView.image = avatarImage?.circleMasked
            }
        } else {
            self.avatarImageView.image = UIImage(named: "avatar")?.circleMasked
        }
    }
}
