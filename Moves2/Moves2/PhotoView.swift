//
//  PhotoView.swift
//  Snacktacular
//
//  Created by Liam Potts on 4/10/23.
//

import SwiftUI
import Firebase

struct PhotoView: View {
    @EnvironmentObject var spotVM: SpotViewModel
    @Binding var photo: Photo
    var uiImage: UIImage
    @Environment(\.dismiss) private var dismiss
    var spot: Spot
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                TextField("Description", text: $photo.description)
                    .textFieldStyle(.roundedBorder)
                    .disabled(Auth.auth().currentUser?.email != photo.reviewer)
                
                Text("by: \(photo.reviewer) on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding()
            .toolbar{
                if Auth.auth().currentUser?.email == photo.reviewer {
                    //image posted by current user
                    ToolbarItemGroup(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItemGroup(placement: .automatic) {
                        Button("Save") {
                            Task{
                                let success = await spotVM.saveImage(spot: spot, photo: photo, image: uiImage)
                                if success {
                                    dismiss()
                                }
                            }
                        }
                    }
                    
                } else {
                    //image not posted by current useer
                    ToolbarItemGroup(placement: .cancellationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
             
            }
     
        }
        
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo:. constant(Photo()), uiImage: UIImage(named: "pizza") ?? UIImage(), spot: Spot())
            .environmentObject(SpotViewModel())
    }
}
