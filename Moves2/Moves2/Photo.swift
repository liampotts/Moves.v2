//
//  Photo.swift
//  Snacktacular
//
//  Created by Liam Potts on 4/9/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""
    var description = ""
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["imageURLString": imageURLString, "description": description, "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
    
    
}
