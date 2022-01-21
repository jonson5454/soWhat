import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Equatable {
    
    //: MARK: PARAMETERS
    var id = ""
    var userName: String
    var email: String
    var password: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    //: MARK: FUNCTIONS
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {

        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER) {
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    print("Error decoding user from user defaults ", error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool{
        lhs.id == rhs.id
    }
}

//: MARK: SAVE USER OBJECT IN USER DEFAULTS
func saveUserLocally(_ user: User) {

    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        //saved user data locally with key as kCurrentuser
        UserDefaults.standard.set(data, forKey: kCURRENTUSER)
    } catch {
        print("Error: ",error.localizedDescription)
    }
}

 