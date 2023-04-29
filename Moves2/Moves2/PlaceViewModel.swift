//
//  PlaceViewModel.swift
//  PlaceLookupDemo
//
//  Created by Liam Potts on 4/2/23.
//

import Foundation
import MapKit

@MainActor
class PlaceViewModel: ObservableObject {
    
    @Published var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print ("😡 ERROR : \(error?.localizedDescription ?? "Unknown ERROR")")
                return
            }
            self.places = response.mapItems.map(Place.init)
        }
    }
    
    
    
    
    
}
