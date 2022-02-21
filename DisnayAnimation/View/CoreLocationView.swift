//
//  CoreLocationView.swift
//  CoreLocationView
//
//  Created by 1 on 18/09/21.
//

import SwiftUI

import CoreLocationUI
import CoreLocation
import MapKit

struct CoreLocationView: View {
    // Create State Object
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Map...
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true            , annotationItems: locationManager.coffeeShops, annotationContent: {
                shop in

                MapMarker(coordinate: shop.mapItem.placemark.coordinate, tint: .purple)
            }) //:Map)


                .ignoresSafeArea()
            
            LocationButton(.currentLocation) {
//                locationManager.manager.requestAlwaysAuthorization()
                locationManager.manager.requestLocation()
            }
            .frame(width: 210, height: 50)
            .symbolVariant(.fill)
            .foregroundColor(.white)
            .tint(.purple)
            .clipShape(Capsule())
            .padding()
            .padding(.bottom, 80)
            
        } //ZStack
    }
}

struct CoreLocationView_Previews: PreviewProvider {
    static var previews: some View {
        CoreLocationView()
    }
}

// Location Manager
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var manager = CLLocationManager()
    
    //Region
    @Published var region: MKCoordinateRegion = .init()
    
    @Published var coffeeShops: [Shop] = []
    
    //setting Delegate
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    } // didFail
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        region = MKCoordinateRegion(center: location, latitudinalMeters: 10, longitudinalMeters: 10)
    
        
        // caling Task
        async {
        await fetchCoffeShop()
        }
    } // didUpdate
    
    //Fetching Location Search Aync Task...
    func fetchCoffeShop() async {
        
        do {
            
            let request = MKLocalSearch.Request()
            request.region = region
            request.naturalLanguageQuery = "Coffee Shop"
            
            let query = MKLocalSearch(request: request)
            
            let response = try await query.start()
            // Mapping Map item
            
            //You can also use DispatchQueue
            await MainActor.run {
                self.coffeeShops = response.mapItems.compactMap{ item in
                    return Shop(mapItem: item)
                }
            }
        } catch {
            
        }
    } // fetchCoffeShop
} // class

//Sample Model for Map Pins
struct Shop: Identifiable {
    var id = UUID().uuidString
    var mapItem: MKMapItem
}
