//
//  FirebaseRecentListner.swift
//  sowhat
//
//  Created by a on 1/28/22.
//

import Foundation
import Firebase

class FirebaseRecentListner {
    
    static let shared = FirebaseRecentListner()
    
    private init() {}
    
    func downloadRecentChatsFromFireStore(completion: @escaping (_ allRecents: [RecentChat]) -> Void) {
        
        FirebaseRefrence(.Recent).whereField(kSENDERID, isEqualTo: User.currentId).addSnapshotListener { (querySnapshot, error) in
            
            var recentChats: [RecentChat] = []
            
            guard let documents = querySnapshot?.documents else {
                print("no documents for recent chats")
                return
            }
            
            let allRecents = documents.compactMap { (queryDucomentSnapshot) -> RecentChat? in
                return try? queryDucomentSnapshot.data(as: RecentChat.self)
            }
            
            for recent in allRecents {
                if recent.lastMessage != "" {
                    recentChats.append(recent)
                }
            }
            
            recentChats.sort(by: { $0.date! > $1.date! })
            completion(recentChats)
        }
    }
    
    func resetRecentCounter(chatRoomID: String) {
        
        FirebaseRefrence(.Recent).whereField(kCHATROOMID, isEqualTo: User.currentId).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("No document for recent ")
                return
            }
            
            let allRecents = documents.compactMap { (queryDocumentSnapshot) -> RecentChat? in
                
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            
            if allRecents.count > 0 {
                self.clearUnreadCounter(recent: allRecents.first!)
            }
        }
    }
    
    func clearUnreadCounter(recent: RecentChat) {
        
        var newRecent = recent
        newRecent.unreadCounter = 0
        self.saveRecent(newRecent)
    }
    
    func saveRecent(_ recent: RecentChat) {
        
        do {
            try FirebaseRefrence(.Recent).document(recent.id).setData(from: recent)
        }
        catch {
            print("Error saving recent chat ", error.localizedDescription)
        }
    }
    
    func deleteRecent(_ recent: RecentChat) {
        FirebaseRefrence(.Recent).document(recent.id).delete()
    }
    
}
