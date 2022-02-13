

import Foundation
import FirebaseFirestore

//: MARK: It returns top level folder refrence e.g User, Channel, Recent e.c
//: IT returns firebase collection refrence as top level folder category

enum FCollectionRefrence: String {
    case User
    case Recent
    case Messages
    case Typing
}

// Helper function to provide top level folders
func FirebaseRefrence (_ collectionRefrence: FCollectionRefrence) -> CollectionReference {
    return Firestore.firestore().collection(collectionRefrence.rawValue)
}

