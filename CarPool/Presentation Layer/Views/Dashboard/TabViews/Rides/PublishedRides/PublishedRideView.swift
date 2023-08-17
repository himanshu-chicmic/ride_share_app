//
//  PublishedRideView.swift
//  CarPool
//
//  Created by Nitin on 8/9/23.
//

import SwiftUI

struct PublishedRideView: View {
    
    // MARK: - properties
    
    // selected ride data
    var data: Publish?
    
    // search view model
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var confirmBeforeCancel: Bool = false
    
    var rideStatus: String {
        return Helpers.getRideStatus(status: data?.status.lowercased() ?? "")
    }
    
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
            
            if let rideData = data {
                ScrollView {
                    
                    // departure date
                    HStack {
                        Text(Formatters.getLongDate(date: rideData.date ?? Constants.Placeholders.defaultTime))
                            .font(.system(size: 20, weight: .bold))
                            .padding([.vertical, .leading])
                        
                        Text(rideStatus.capitalized)
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .foregroundColor(Helpers.returnStatusColor(rideStatus: rideStatus.lowercased()))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 16)
                            .background(Helpers.returnStatusColor(rideStatus: rideStatus.lowercased()).opacity(0.1))
                        
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
                            
                            LocationTextView(title: Formatters.getFormattedDate(date: rideData.estimateTime), location: rideData.destination)
                        }
                        .padding(.leading, 8)
                    }
                    .padding()
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.05))
                        .background(.gray.opacity(0.05))
                    
                    // ride info
                    RideDetailsInformationView(details: rideData.getDetailsArray(data: rideData))
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
                    
                    // vehicle info
                    RideDetailVehicleInformation()
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.05))
                        .background(.gray.opacity(0.05))
                        .padding(.vertical)
                    
                    Text("Passengers")
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // passengers info
                    if let passengers = searchViewModel.publishedRideSingleData?.passengers {
                        ForEach(passengers, id: \.userID) { passenger in
                            HStack (alignment: .center) {
                                LoadImageView(driverImage: passenger.image ?? "", isLoading: true)
                                
                                VStack (alignment: .leading) {
                                    Text("\(passenger.firstName ?? "") \(passenger.lastName ?? "")")
                                        .font(.system(size: 15))
                                    Text("\(passenger.phoneNumber ?? "")")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 13))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                }
                .scrollIndicators(.hidden)
                
                if rideData.status.lowercased() == "pending" {
                    
                    Button {
                        searchViewModel.editRideView.toggle()
                    } label: {
                        DefaultButtonLabel(text: Constants.RideDetails.editRide)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, rideData.status.lowercased() == "pending" ? 0 : 10)
                    
                    Button {
                        // cancel ride
                        confirmBeforeCancel.toggle()
                    } label: {
                        DefaultButtonLabel(text: Constants.RideDetails.cancelRide, isPrimary: false, color: .red.opacity(0.8))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .confirmationDialog(
            Constants.AlertDialog.areYouSure,
            isPresented     : $confirmBeforeCancel,
            titleVisibility : .visible
        ) {
            Button(Constants.Others.continue_, role: .destructive) {
                if let rideData = data {
                    searchViewModel.cancelRideBooking(httpMethod: .POST, requestType: .cancelPublished, data: [Constants.JsonKeys.id : rideData.id])
                }
            }
            Button(Constants.Others.dismiss, role: .cancel) {}
        }
        .fullScreenCover(isPresented: $searchViewModel.editRideView) {
            EditPublishedRide(data: data)
        }

        .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
    }
}

struct PublishedRideView_Previews: PreviewProvider {
    static var previews: some View {
        PublishedRideView(data: Publish(id: 373, source: "Business & Industrial Park 1, Chandigarh", destination: "Sector 118, Mohali", passengersCount: 4, addCity: nil, date: "2023-06-15", time: "2000-01-01T10:41:00.000Z", setPrice: Double(Int(200.0)), aboutRide: "", userID: 256, createdAt: "2023-06-12T05:12:43.252Z", updatedAt: "2023-06-12T05:12:43.252Z", sourceLatitude: 30.704758007382228, sourceLongitude: 76.801208, destinationLatitude: 30.737185, destinationLongitude: 76.678551, vehicleID: 218, bookInstantly: nil, midSeat: nil, selectRoute: SelectRoute(routes: []), status: "pending", estimateTime: "2000-01-01T00:33:58.000Z", addCityLongitude: nil, addCityLatitude: nil, distance: 0.08185672694379517, bearing: "183.744259068662"))
            .environmentObject(BaseViewModel())
            .environmentObject(SearchViewModel())
    }
}
