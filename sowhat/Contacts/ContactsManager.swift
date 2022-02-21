//
//  ContactsManager.swift
//  sowhat
//
//  Created by a on 2/18/22.
//

import Foundation
import Contacts
import Firebase
import UIKit

let contactsManager = ContactsManager()

final class ContactsManager: NSObject {
    
    //MARK: - Contacts Veriables
    var objects = [CNContact]()
    var jsonArray: [[String: String]] = [[String: String]]()
    
    //get contacts
    func getContacts() {
        
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            
            self.retreiveContactWithStore(store: store)
        case .notDetermined:
            store.requestAccess(for: .contacts) { success, error in
                guard error == nil && success else {
                    return
                }
                self.retreiveContactWithStore(store: store)
            }
        default:
            print("Not Handled")
        }
    }
    
    //retreive contact with store
    func retreiveContactWithStore(store: CNContactStore) {
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey
        ] as Any
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        var cnContacts = [CNContact]()
        
        //loop for to fetch contact list.
        do {
            
            try store.enumerateContacts(with: request) {(contact, cursor) in
                
                if (!contact.phoneNumbers.isEmpty) {
                    if let contactImageData = contact.imageData {
                        //image data is available bind with phone number to upload.
                    }
                } else {
                    print("images not found")
                }
                if (!contact.emailAddresses.isEmpty) {
                    //email address is available.
                }
                cnContacts.append(contact) //append the current contact to the contacts list
                self.objects = cnContacts //assign the contacts list to object to pass data.
            }
            uploadInfo()
        } catch let error {
            NSLog("Fetch contact error: \(error)")
        }
        
    }
    
    //contacts list
    func uploadInfo() {
        
        var _: [String: String] = ["": ""]
        
        var name = ""
        var number = ""
        
        for i in 0..<self.objects.count {
            let contact = self.objects[i]
            
            let formatter = CNContactFormatter()
            name = formatter.string(from: contact) ?? ""
            if let actualNumber = contact.phoneNumbers.first?.value {
                number = actualNumber.stringValue
            } else {
                number = "N.A"
            }
            //it's time to convert number into json
            let json = (["name": name, "number": number])
        }
        
        //now send the contact array to the firebase to update user array
        updateUserContactsList()
    }
    
    func updateUserContactsList() {
        
        //Here we save user contacts in FB Collection inside user array file.
        if var user = User.currentUser {
            user.contactListArray = self.jsonArray
            saveUserLocally(user)
            FirebaseUserListner.shared.updateUserInFirebase(user)
        }
        
    }
}
