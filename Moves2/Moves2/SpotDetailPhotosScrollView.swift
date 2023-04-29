//
//  SpotDetailPhotosScrollView.swift
//  Snacktacular
//
//  Created by Liam Potts on 4/10/23.
//

import SwiftUI

struct SpotDetailPhotosScrollView: View {
    
//    struct FakePhoto: Identifiable {
//        let id = UUID().uuidString
//        var imageURLString = "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-e84df.appspot.com/o/Bz5ipL8SGDDjrtwGZkSv%2F8B4BC836-79C4-480C-A539-BEBCDDF86C1D.jpeg?alt=media&token=a077371d-5bd3-4f94-b765-52af56994fc5"
//    }
//
//    let photos = [FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto()]
//
    
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State private var selectedPhoto = Photo()
    
    var photos: [Photo]
    var spot: Spot
    
    
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack (spacing: 4){
                ForEach(photos) { photo in
                    
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .onTapGesture {
                                let renderer = ImageRenderer(content: image)
                                selectedPhoto = photo
                                uiImage = renderer.uiImage ?? UIImage()
                                showPhotoViewerView.toggle()
                            }
                        
                        
                        
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
        .sheet(isPresented: $showPhotoViewerView) {
            PhotoView(photo: $selectedPhoto, uiImage: uiImage, spot: spot)
        }
    }
}

struct SpotDetailPhotosScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SpotDetailPhotosScrollView(photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-e84df.appspot.com/o/Bz5ipL8SGDDjrtwGZkSv%2F8B4BC836-79C4-480C-A539-BEBCDDF86C1D.jpeg?alt=media&token=a077371d-5bd3-4f94-b765-52af56994fc5")], spot: Spot(id: "Bz5ipL8SGDDjrtwGZkSv"))
    }
}
