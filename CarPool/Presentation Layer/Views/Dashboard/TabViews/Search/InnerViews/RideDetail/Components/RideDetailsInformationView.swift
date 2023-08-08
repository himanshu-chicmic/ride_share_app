//
//  RideDetailsInformationView.swift
//  CarPool
//
//  Created by Nitin on 6/12/23.
//

import SwiftUI

struct RideDetailsInformationView: View {
    
    var data: Publish
    
    @State var details: [String] = []
    
    var body: some View {
        VStack (alignment: .leading) {
            
            Text(Constants.RideDetails.details)
                .padding(.bottom, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(details, id: \.self) { value in
                if !value.isEmpty {
                    Text(value)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .padding(.vertical, 2)
                }
            }
        }
        .onAppear {
            details = data.getDetailsArray(data: data)
        }
    }
}

struct RideDetailsInformationView_Previews: PreviewProvider {
    static var previews: some View {
        RideDetailsInformationView(
            data: Publish(id: 373, source: "Business & Industrial Park 1, Chandigarh", destination: "Sector 118, Mohali", passengersCount: 4, addCity: nil, date: "2023-06-15", time: "2000-01-01T10:41:00.000Z", setPrice: Double(Int(200.0)), aboutRide: "", userID: 256, createdAt: "2023-06-12T05:12:43.252Z", updatedAt: "2023-06-12T05:12:43.252Z", sourceLatitude: 30.704758007382228, sourceLongitude: 76.801208, destinationLatitude: 30.737185, destinationLongitude: 76.678551, vehicleID: 218, bookInstantly: nil, midSeat: nil, selectRoute: SelectRoute(routes: []), status: "pending", estimateTime: "2000-01-01T00:33:58.000Z", addCityLongitude: nil, addCityLatitude: nil, distance: 0.08185672694379517, bearing: "183.744259068662")
        )
    }
}
