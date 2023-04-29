//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Liam Potts on 3/27/23.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage


@MainActor
class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    func saveSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore() // ignore error
        
        if let id = spot.id {
            do {
                try await db.collection("spots").document(id).setData(spot.dictionary)
                print("😎 Data added successfully!")
                return true
                
            } catch {
                print(" 😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
               let documentRef = try await db.collection("spots").addDocument(data: spot.dictionary)
                
                self.spot = spot
                self.spot.id = documentRef.documentID 
                
                
                print("😎 Data added successfully!")
                return true
                
            } catch {
                print("😡 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func saveImage(spot: Spot, photo: Photo, image: UIImage) async -> Bool {
        guard let spotID = spot.id else {
            print ("😡 ERROR: spot.id  nil")
            return false
        }
        
        
        var photoName = UUID().uuidString
        if photo.id != nil {
            photoName = photo.id! 
        }
        let storeage = Storage.storage()
        let storeageRef = storeage.reference().child("\(spotID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("😡 ERROR: could not resize image")
            return false
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        var imageURLString = ""
        
        do {
            let _ = try await storeageRef.putDataAsync(resizedImage, metadata: metadata)
            print("📸 Image Saved!")
            do {
                let imageURL = try await storeageRef.downloadURL()
                imageURLString = "\(imageURL)"
            } catch {
                print("😡 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
                return false
            }
        } catch {
            print("😡 ERROR: uploading image to FirebaseStorage")
            return false
        }
        //Now save to the "photos" collection of the spot document "spotID
        let db = Firestore.firestore()
        let collectionString = "spots/\(spotID)/photos"
        
        do{
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
            print("😎 Data updated successfully")
            return true
        } catch {
            print("😡 ERROR: Could not update data in 'photos' for spotID \(spotID)")
            return false
        }
        
        
        
    }
    
}
