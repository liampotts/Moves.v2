//
//  PlaceLookupView.swift
//  PlaceLookupDemo
//
//  Created by Liam Potts on 4/2/23.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    
    @State private var searchText = ""
    @Binding var spot : Spot
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        
        
        NavigationStack{
            List(placeVM.places) { place in
                VStack (alignment: .leading){
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                }
                .onTapGesture {
                    spot.name = place.name
                    spot.address = place.address
                    spot.longitude = place.longitude
                    spot.latitude = place.latitude
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { text in
                if text.isEmpty {
                    placeVM.search(text: text, region: locationManager.region)
                } else {
                    placeVM.places = []
                }
                
                
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss"){
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PlaceLookupView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceLookupView(spot: .constant(Spot()))
            .environmentObject(LocationManager())
    }
}
