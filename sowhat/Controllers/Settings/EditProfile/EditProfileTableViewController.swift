//
//  EditProfileTableViewController.swift
//  sowhat
//
//  Created by a on 1/20/22.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController {

    //: MARK: IBOUTLETS
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    
    //: MARK: PROPERTIES
    var gallery: GalleryController!
    
    //: MARK: VIEWLIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        configureTextField()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        showUserInfo()
    }
    
    //: MARK: TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //TODO: show status view
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileToStatusSeg", sender: self)
        }
    }
    
    //: MARK: IBACTION
    @IBAction func editButtonPressed(_ sender: Any) {
        
        showImageGallery()
    }
    

    //: Show User Info
    func showUserInfo() {
        
        if let user = User.currentUser {
            
            userNameTextField.text = user.userName
            statusLabel.text = user.status
            
            if user.avatarLink != ""{
                //set avatar
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
    
    //: MARK: CONFIGURE
    func configureTextField() {
        userNameTextField.delegate = self
        userNameTextField.clearButtonMode = .whileEditing
    }
    
    //:MARK: - Gallery
    func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self

        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
    }
    
    //TODO: UPLOAD IMAGE
    func uploadAvatarImage(_ image: UIImage) {
        
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        
        FileStorage.uploadImage(image, directory: fileDirectory) {(avatarLink) in
            
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListner.shared.saveUserToFirestore(user: user)
            }
            //TODO: Save Image Locally
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: User.currentId)
        }
        
    }
}

//: MARK: Edit Text Field Extension
extension EditProfileTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            
            if textField.text != "" {
                
                if var user = User.currentUser {
                    user.userName = textField.text!
                    saveUserLocally(user)
                    FirebaseUserListner.shared.saveUserToFirestore(user: user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

extension EditProfileTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            images.first?.resolve {(avatarImage) in
                
                if avatarImage != nil {
                    //TODO: UPLOAD IMAGE
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImageView.image = avatarImage?.circleMasked
                } else {
                    ProgressHUD.show("Couldn't select image!")
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
