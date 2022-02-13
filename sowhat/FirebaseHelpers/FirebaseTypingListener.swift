//
//  FirebaseTypingListener.swift
//  sowhat
//
//  Created by Ghulam Mujtaba on 13/02/2022.
//

import Foundation
import Firebase

class FirebaseTypingListener {
    
    //MARK: - Vars
    static let shared = FirebaseTypingListener()
    
    var typingListener: ListenerRegistration!
    
    private init() { }
    
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> Void) {
        
        typingListener = FirebaseRefrence(.Typing).document(chatRoomId).addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            if snapshot.exists {
                
                for data in snapshot.data()! {
                    
                    if data.key != User.currentId {
                        completion(data.value as! Bool)
                    }
                }
            } else {
                completion(false)
                FirebaseRefrence(.Typing).document(chatRoomId).setData([User.currentId : false])
            }
        })
    }
    
    class func saveTypingCounter(typing: Bool, chatRoomId: String) {
        FirebaseRefrence(.Typing).document(chatRoomId).setData([User.currentId : typing])
    }
        
    func removeTypingListener() {
        typingListener.remove()
    }
}
