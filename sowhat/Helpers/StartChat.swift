//
//  StartChat.swift
//  sowhat
//
//  Created by a on 1/28/22.
//

import Foundation
import Firebase

//: MARK: START CHAT
func startChat(user1: User, user2: User) -> String {
    
    let chatRoomId = chatRoomIdFrom(user1Id: user1.id, user2Id: user2.id)
    
    createRecentItems(chatRoomId: chatRoomId, users: [user1, user2])
    
    return chatRoomId
}

func restartChat(chatRoomId: String, memberIds: [String]) {
    
    FirebaseUserListner.shared.downloadUsersFromFirebase(widthIDs: memberIds) { (users) in
        
        if users.count > 0 {
            createRecentItems(chatRoomId: chatRoomId, users: users)
        }
    }
}

func createRecentItems(chatRoomId: String, users: [User]) {
    
    var memberIdsToCreateRecent = [users.first!.id, users.last!.id]
    
    print("members to create recent is ", memberIdsToCreateRecent)
    //does user have recent
    FirebaseRefrence(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapShot, error) in
        
        guard let snapShot = snapShot else { return }
        
        if !snapShot.isEmpty {
            
            memberIdsToCreateRecent = removeMemberWhoHasRecent(snapShot: snapShot, memberIds: memberIdsToCreateRecent)
            print("updated members to create recent is ", memberIdsToCreateRecent)
        }
        
        for userId in memberIdsToCreateRecent {
            
            print("creating recent for user with id ", userId)
            
            let senderUser = userId == User.currentId ? User.currentUser! : getReceiverFrom(users: users)
            
            let receiverUser = userId == User.currentId ? getReceiverFrom(users: users) : User.currentUser!
            
            let recentObject = RecentChat(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.userName, receiverId: receiverUser.id, receiverName: receiverUser.userName, date: Date(), memberIds: [senderUser.id, receiverUser.id], lastMessage: "", unreadCounter: 0, avatarLink: receiverUser.avatarLink)
            
            FirebaseRecentListner.shared.saveRecent(recentObject)
        }
    }
    
}

func removeMemberWhoHasRecent(snapShot: QuerySnapshot, memberIds: [String]) -> [String] {
    
    var memberIdsToCreateRecent = memberIds
    
    for recentData in snapShot.documents {
        
        let currentRecent = recentData.data() as Dictionary
        
        if let currentUserId = currentRecent[kSENDERID] {
            
            if memberIdsToCreateRecent.contains(currentUserId as! String) {
                
                memberIdsToCreateRecent.remove(at: memberIdsToCreateRecent.firstIndex(of: currentUserId as! String)!)
            }
        }
    }
    return memberIdsToCreateRecent
}

func chatRoomIdFrom(user1Id: String, user2Id: String) -> String {
    
    var chatRoomId = ""
    
    let value = user1Id.compare(user2Id).rawValue
    
    chatRoomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    
    return chatRoomId
    
}

func getReceiverFrom(users: [User]) -> User {

    var allUsers = users
    
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)

    return allUsers.first!
}
