//
//  FirebaseMessageListner.swift
//  sowhat
//
//  Created by Ghulam Mujtaba on 12/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseMessageListner {
    
    static let shared = FirebaseMessageListner()
    var newChatListener: ListenerRegistration!
    var updatedChatListener: ListenerRegistration!
    
    private init() { }
    
    func listenForNewChats(_ documentId: String, collectionId: String, lastMessageDate: Date) {
        
        newChatListener = FirebaseRefrence(.Messages).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ querySnapshot, error in
            
            guard let snapshot = querySnapshot else { return }
            
            for changes in snapshot.documentChanges {
                if changes.type == .added {
                    
                    let result = Result {
                        try? changes.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        
                        if let message = messageObject {
                            
                            if message.senderId != User.currentId {
                                RealmManager.shared.saveToRealm(message)
                            }
                        } else {
                         print("document doesn't exist")
                        }
                        
                    case .failure(let error):
                        print("Error decoding local message \(error.localizedDescription)")
                    }
                }
            }
        })
    }
    
    func listenForReadStatusChange(_ documentId: String, collectionId: String, completion: @escaping (_ updatedMessage: LocalMessage) -> Void) {
        
        FirebaseRefrence(.Messages).document(documentId).collection(collectionId).addSnapshotListener { (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else { return }
            
            for change in snapshot.documentChanges {
                
                if change.type == .modified {
                    
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject {
                            completion(message)
                        } else {
                            print("Document does not exist in chat")
                        }
                    case .failure(let error):
                        print("Error decoding local message: ", error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func checkForOldMessages(_ documentId: String, collectionId: String) {
        
        FirebaseRefrence(.Messages).document(documentId).collection(collectionId).getDocuments {(querySnapshot, error) in
            
            guard let document = querySnapshot?.documents else {
                print("no old chat")
                return
            }
            
            var oldMessages = document.compactMap { (queryDocumentSnapshot) -> LocalMessage? in
                
                return try? queryDocumentSnapshot.data(as: LocalMessage.self)
            }
            
            oldMessages.sort(by: { $0.date < $1.date})
            
            for message in oldMessages {
                RealmManager.shared.saveToRealm(message)
            }
        }
    }
    
    //MARK: - Add, Update, Delete
    
    func addMessage(message: LocalMessage, memberId: String) {
        
        do {
            let _ = try FirebaseRefrence(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch  {
            print("error saving message ", error.localizedDescription)
        }
    }
    
    //MARK: - UpdateMessageStatus
    func updateMessageInFirebase(_ message: LocalMessage, memberIds: [String]) {
        
        let values = [kSTATUS : KREAD, kREADDATE : Date()] as [String : Any]
        
        for userId in memberIds {
            FirebaseRefrence(.Messages).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
        }
    }
    
    func removeListeners() {
        self.newChatListener.remove()
        self.updatedChatListener.remove()
    }
}
