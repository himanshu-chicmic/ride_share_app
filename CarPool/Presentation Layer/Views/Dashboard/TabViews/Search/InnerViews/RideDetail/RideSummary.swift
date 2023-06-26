//
//  RideSummary.swift
//  CarPool
//
//  Created by Nitin on 6/12/23.
//

import SwiftUI

struct RideSummary: View {
    
    var data: Datum?
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack {
            
            // app bar at the top
            ZStack(alignment: .leading) {
                
                // button to pop view
                Button(action: {
                    searchViewModel.openSummaryView.toggle()
                }, label: {
                    Image(systemName: Constants.Icon.close)
                })

                // title for app bar
                Text(Constants.Headings.summary)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            
            Divider()
            
            if let data {
                ScrollView {
                    
                    // departure date
                    Text(
                        Globals.getLongDate(
                                date: data.publish.date ?? Constants.Placeholders.defaultTime
                        )
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    // ride location details
                    HStack {
                        
                        VStack {
                            Image(systemName: Constants.Icon.startLocation)
                            
                            RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                                .frame(width: 1, height: 54)
                            
                            Image(systemName: Constants.Icon.startLocation)
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.blue.opacity(0.75))
                        
                        VStack (alignment: .leading) {
                            
                            LocationTextView(title: Globals.getFormattedDate(date: data.publish.time), location: data.publish.source)
                            
                            Divider()
                                .padding(.bottom)
                            
                            LocationTextView(title: Globals.getFormattedDate(date: data.reachTime), location: data.publish.destination)
                        }
                        .padding(.leading, 8)
                    }
                    .padding()
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.05))
                        .background(.gray.opacity(0.05))
                    
                    // ride info
                    RideDetailsInformationView(data: data)
                        .padding()
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.05))
                        .background(.gray.opacity(0.05))
                    
                    // ride price
                    HStack {
                        Text(Constants.RideDetails.totalPrice)
                        Spacer()
                        
                        Text(Globals.getPrice(price: data.publish.setPrice))
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding()
                    
                    // vehicle info
                    if let vehicleId = data.publish.vehicleID {
                        RideDetailVehicleInformation(vehicleId: vehicleId)
                    }
                    
                }
                .scrollIndicators(.hidden)
                
                Button {
                    searchViewModel.sendRequestForRideBook(httpMethod: .POST, requestType: .bookPublish, data: [
                        Constants.JsonKeys.passengers : [
                            Constants.JsonKeys.publishId : data.publish.id,
                            Constants.JsonKeys.seats : searchViewModel.numberOfPersons
                        ]
                    ])
                } label: {
                    DefaultButtonLabel(
                        text: "Confirm Ride")
                }
                .padding()
            }
        }
        .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
    }
}

struct RideSummary_Previews: PreviewProvider {
    static var previews: some View {
        RideDetailView(data: Datum(id: 256, name: "Himanshu", reachTime: "2023-06-15T11:14:58.000Z", imageURL: nil, averageRating: nil, aboutRide: "", publish: Publish(id: 373, source: "Business & Industrial Park 1, Chandigarh", destination: "Sector 118, Mohali", passengersCount: 4, addCity: nil, date: "2023-06-15", time: "2000-01-01T10:41:00.000Z", setPrice: Int(200.0), aboutRide: "", userID: 256, createdAt: "2023-06-12T05:12:43.252Z", updatedAt: "2023-06-12T05:12:43.252Z", sourceLatitude: 30.704758007382228, sourceLongitude: 76.801208, destinationLatitude: 30.737185, destinationLongitude: 76.678551, vehicleID: 218, bookInstantly: nil, midSeat: nil, selectRoute: SelectRoute(routes: []), status: "pending", estimateTime: "2000-01-01T00:33:58.000Z", addCityLongitude: nil, addCityLatitude: nil, distance: 0.08185672694379517, bearing: "183.744259068662")))
            .environmentObject(BaseViewModel())
            .environmentObject(SearchViewModel())
    }
}
