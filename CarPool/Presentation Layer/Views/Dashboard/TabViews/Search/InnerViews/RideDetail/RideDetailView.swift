//
//  RideDetailView.swift
//  CarPool
//
//  Created by Nitin on 5/26/23.
//

import SwiftUI

struct RideDetailView<T: Any>: View {
    
    // MARK: - properties
    
    // selected ride data
    var data: T?
    
    var rideData: Publish? {
        if let data = data as? Datum {
            return data.publish
        } else if let data = data as? BookedRidesData {
            return data.ride
        }
        return nil
    }
    
    var reachTime: String {
        var time: String = ""
        if let data = data as? Datum {
            time = data.reachTime!
        } else if let data = data as? BookedRidesData {
            time = data.reachTime!
        }
        return time
    }
    
    // search view model
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - body
    
    var body: some View {
        
        VStack {
            
            // app bar
            ZStack(alignment: .leading) {
                
                // button to pop view
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: Constants.Icon.back)
                })

                // title for app bar
                Text(Constants.Headings.rideDetails)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            
            Divider()
            
            if let rideData = rideData {
                ScrollView {
                    
                    // departure date
                    HStack {
                        Text(Formatters.getLongDate(date: rideData.date ?? Constants.Placeholders.defaultTime))
                            .font(.system(size: 20, weight: .bold))
                            .padding([.vertical, .leading])
                        
                        if data as? BookedRidesData != nil {
                            Text(rideData.status.capitalized)
                                .font(.system(size: 13))
                                .fontWeight(.medium)
                                .foregroundColor(Formatters.returnStatusColor(rideStatus: rideData.status.lowercased()))
                                .padding(.vertical, 4)
                                .padding(.horizontal, 16)
                                .background(Formatters.returnStatusColor(rideStatus: rideData.status.lowercased()).opacity(0.1))
                        }
                        
                        Spacer()
                    }
                    
                    // ride location details
                    HStack {
                        
                        VStack {
                            Image(systemName: Constants.Icon.startLocation)
                            
                            RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                                .frame(width: 1, height: 54)
                            
                            Image(systemName: Constants.Icon.startLocation)
                        }
                        .font(.system(size: 12))
                        .foregroundColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                        
                        VStack (alignment: .leading) {
                            
                            LocationTextView(title: Formatters.getFormattedDate(date: rideData.time), location: rideData.source)
                            
                            Divider()
                                .padding(.bottom)
                            
                            LocationTextView(title: Formatters.getFormattedDate(date: reachTime), location: rideData.destination)
                        }
                        .padding(.leading, 8)
                    }
                    .padding()
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.05))
                        .background(.gray.opacity(0.05))
                    
                    // ride info
                    RideDetailsInformationView(data: rideData)
                        .padding()
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.05))
                        .background(.gray.opacity(0.05))
                    
                    // ride price
                    HStack {
                        Text(Constants.RideDetails.totalPrice)
                        Spacer()
                        
                        Text(Formatters.getPrice(price: Int(rideData.setPrice)))
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding()
                    
                    // driver details
                    if let data = data as? Datum {
                        
                        Rectangle()
                            .frame(height: 4)
                            .foregroundColor(.gray.opacity(0.05))
                            .background(.gray.opacity(0.05))
                        
                        HStack {
                            
                            // driver profile image
                            LoadImageView(driverImage: data.imageURL ?? "")
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(data.name)
                                    .font(.system(size: 15, weight: .semibold))
                                // ratings received by driver
                                HStack (
                                    alignment: .center,
                                    spacing: 4
                                ) {
                                    Image(systemName: Constants.Icon.star)
                                        .resizable()
                                        .frame(
                                            width  : 13,
                                            height : 13
                                        )
                                    Text(Formatters.getRatings(ratings: data.averageRating ?? 0))
                                }.font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding()
                    }
                    
                    // vehicle info
                    RideDetailVehicleInformation()
                    
                    if data as? Datum != nil {
                        // buttons view
                        RideDetailsButtonsView()
                    }
                }
                .scrollIndicators(.hidden)
                
                if data as? Datum != nil {
                    Button {
                        searchViewModel.openSummaryView.toggle()
                    } label: {
                        DefaultButtonLabel(text: Constants.RideDetails.bookRide)
                    }
                    .padding()
                } else {
                    Button {
                        // message driver
                    } label: {
                        DefaultButtonLabel(text: Constants.RideDetails.messageDriver)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, rideData.status.lowercased() == "pending" ? 0 : 10)
                    
                    if rideData.status.lowercased() == "pending" {
                        Button {
                            // cancel ride
                        } label: {
                            DefaultButtonLabel(text: Constants.RideDetails.cancelRide, isPrimary: false, color: .red.opacity(0.8))
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $searchViewModel.openSummaryView) {
            RideSummary(data: (data as? Datum)!)
        }
        .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
    }
}

struct RideDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RideDetailView<Any>(data: Datum(id: 256, name: "Himanshu", reachTime: "2023-06-15T11:14:58.000Z", imageURL: nil, averageRating: nil, aboutRide: "", publish: Publish(id: 373, source: "Business & Industrial Park 1, Chandigarh", destination: "Sector 118, Mohali", passengersCount: 4, addCity: nil, date: "2023-06-15", time: "2000-01-01T10:41:00.000Z", setPrice: Double(Int(200.0)), aboutRide: "", userID: 256, createdAt: "2023-06-12T05:12:43.252Z", updatedAt: "2023-06-12T05:12:43.252Z", sourceLatitude: 30.704758007382228, sourceLongitude: 76.801208, destinationLatitude: 30.737185, destinationLongitude: 76.678551, vehicleID: 218, bookInstantly: nil, midSeat: nil, selectRoute: SelectRoute(routes: []), status: "pending", estimateTime: "2000-01-01T00:33:58.000Z", addCityLongitude: nil, addCityLatitude: nil, distance: 0.08185672694379517, bearing: "183.744259068662")))
            .environmentObject(BaseViewModel())
            .environmentObject(SearchViewModel())
    }
}
