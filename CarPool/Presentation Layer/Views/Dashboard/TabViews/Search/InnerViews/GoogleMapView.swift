//
//  GoogleMapView.swift
//  CarPool
//
//  Created by Nitin on 6/28/23.
//

import SwiftUI
import GoogleMaps
import Alamofire
import SwiftyJSON

struct GoogleMapView: UIViewRepresentable {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        // MARK: Define the source latitude and longitude
        let sourceLat = searchViewModel.startLocationVal?.geometry.location.lat ?? 0
        let sourceLng = searchViewModel.startLocationVal?.geometry.location.lng ?? 0
            
        // MARK: Define the destination latitude and longitude
        let destinationLat = searchViewModel.endLocationVal?.geometry.location.lat ?? 0
        let destinationLng = searchViewModel.endLocationVal?.geometry.location.lng ?? 0
        
        let sourceLocation = "\(sourceLat),\(sourceLng)"
        let destinationLocation = "\(destinationLat),\(destinationLng)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=\(Globals.fetchAPIKey())"
        
        let camera = GMSCameraPosition.camera(withLatitude: sourceLat, longitude: sourceLng, zoom: 10)
        let mapView = GMSMapView(frame: CGRect.zero)
        // MARK: Request for response from the google
        
        AF.request(url).responseJSON { (reseponse) in
            guard let data = reseponse.data else {
                return
            }
            
            do {
                let jsonData = try JSON(data: data)
                let routes = jsonData["routes"].arrayValue
                
                for route in routes {
                    let overview_polyline = route["overview_polyline"].dictionary
                    let points = overview_polyline?["points"]?.string
                    let path = GMSPath.init(fromEncodedPath: points ?? "")
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeColor = .systemBlue
                    polyline.strokeWidth = 5
                    polyline.map = mapView
                    
                    searchViewModel.estimatedTime = Globals.convertSecondsToTime(seconds: route["legs"][0]["duration"]["value"].rawValue as? Double ?? 0)
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        // MARK: Marker for source location
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLng)
        sourceMarker.title = searchViewModel.startLocationVal?.formattedAddress
        sourceMarker.map = mapView
        
        // MARK: Marker for destination location
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
        destinationMarker.title = searchViewModel.endLocationVal?.formattedAddress
        destinationMarker.map = mapView
        
        mapView.animate(to: camera)
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
       
    }
}

struct GoogleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapView()
            .environmentObject(SearchViewModel())
    }
}
