
import Foundation
import Firebase
import UIKit

//: MARK: This class used to login or register or download files from firebase

class FirebaseUserListner {
    
    //: MARK: SINGLETON
    static let shared = FirebaseUserListner()
    
    //: MARK: LOGIN
    func loginUserWithEmail(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil && authDataResult!.user.isEmailVerified {
     
                FirebaseUserListner.shared.downloadUserToFirestore(userId: authDataResult!.user.uid, email: email)
                
                completion(error, true)
            } else {
                print("Email is not verified")
                completion(error, false)
            }
        }
    }
    
    //: MARK: REGISTER
    func registerUserWith(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            
            if authDataResult?.user != nil {
                
                //send verification email
                authDataResult!.user.sendEmailVerification { (error) in
                    print("Auth email sent with error:  ", error?.localizedDescription)
                }
                
                //Create user and save it
                let user = User(id: authDataResult!.user.uid, userName: email, email: email,password: password, pushId: "", avatarLink: "", status: "Hey there I'm using Messenger")
                
                saveUserLocally(user)
                self.saveUserToFirestore(user: user)
            } else {
                print("authDataResult is nil!")
            }
        }
    }
    
    //MARK: - RESEND LINK methods
    func resendVerificationWith(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { error in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    //: MARK: - RESET PASSWORD
    func resetPasswordFor(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    //: Log out user
    func logOutCurrentUser(completion: @escaping(_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            
            completion(nil)
        } catch let error as NSError {
            completion(error)
        }
    }
    
    //MARK: - SAVE USERS
    //: THIS FUNCTION SAVE USER TO FIRESTORE
    func saveUserToFirestore(user: User) {
        do {
            try FirebaseRefrence(.User).document(user.id).setData(from: user)
        } catch {
            print("Adding user error: ", error.localizedDescription)
        }
    }
    
    //: MARK: DOWNLOAD USER FROM FIREBASE
    //: USER IAMGES, USER OBJECT AND USER ANYTHING
    func downloadUserToFirestore(userId: String, email: String? = nil){
        
        //: User the FirestoreRefrence here
        FirebaseRefrence(.User).document(userId).getDocument {(querySnapshot, error) in
            
            guard let document = querySnapshot else {
                print("No document for user.")
                return
            }
            let result = Result {
                try? document.data(as: User.self)
            }
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("error decoding user! ", error)
            }
        }
    }
    
    func downloadAllUsersFromFirebase(completion: @escaping (_ allUsers: [User]) -> Void) {
        
        var users: [User] = []
        
        FirebaseRefrence(.User).limit(to: 500).getDocuments { (querySnapshot, error) in
            
            guard let document = querySnapshot?.documents else {
                print("no documents in all users")
                return
            }
            
            let allUsers = document.compactMap { (queryDocumentSnapshot) -> User? in
                return try? queryDocumentSnapshot.data(as: User.self)
            }
            
            for user in allUsers {
                if User.currentId != user.id {
                    users.append(user)
                }
            }
            
            completion(users)
        }
    }
    
    func downloadUsersFromFirebase(widthIDs: [String], completion: @escaping (_ allUsers: [User]) -> Void) {
        
        var count = 0
        var usersArray: [User] = []
        
        for userID in widthIDs {
            
            FirebaseRefrence(.User).document(userID).getDocument { (querySnapshot, error) in
                
                guard let document = querySnapshot else {
                    print("no document for user")
                    return
                }
                
                let user = try? document.data(as: User.self)
                
                usersArray.append(user!)
                count += 1
                
                if count == widthIDs.count {
                    completion(usersArray)
                }
            }
        }
    }
    
    //: MARK: REGISTER USER WITH APPLE ID
    //: HERE WE CREATE USER ACCOUNT WITH APPLE ID OR SAVE DATA INSIDE ALREADY CREATED USER COLLECTION
    func registerUserWith(appleID: String, password: String) {
        
        
    }
    
    //MARK: - Update
    
    func updateUserInFirebase(_ user: User) {
        
        do {
            let _ = try FirebaseRefrence(.User).document(user.id).setData(from: user)
        } catch {
            print(error.localizedDescription, "updating user...")
        }
    }
}
