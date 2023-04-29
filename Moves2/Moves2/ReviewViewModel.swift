//
//  ReviewViewModel.swift
//  Snacktacular
//
//  Created by Liam Potts on 4/3/23.
//

import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func saveReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore() // ignore error
        
        
        guard let spotID = spot.id else {
            print("😡 ERROR: spot.id = nil")
            return false
        }
        let collectionString = "spots/\(spotID)/reviews"
        
        if let id = review.id {
            do {
                try await db.collection(collectionString).document(id).setData(review.dictionary)
                print("😎 Data added successfully!")
                return true
                
            } catch {
                print(" 😡 ERROR: Could not update data in 'reviews' \(error.localizedDescription)")
                return false
            }
        } else {
            
            do {
               _ = try await db.collection(collectionString).addDocument(data: review.dictionary)
                print("😎 Data added successfully!")
                return true
                
            } catch {
                print("😡 ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func deleteReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()
        guard let spotID = spot.id , let reviewID = review.id else {
            print ("😡 ERROR: spotID = \(spot.id ?? "nil") reviewID = \(review.id ?? "nil") This should not have happened")
            return false
        }
        
        do {
            let _ = try await db.collection("spots").document(spotID).collection("reviews").document(reviewID).delete()
            print("🗑️ Document successfully deleted")
            return true
        } catch {
            print("😡 ERROR: removing document: \(error.localizedDescription)")
            return false
        }
    }
}

