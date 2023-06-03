//
//  RideDetailView.swift
//  CarPool
//
//  Created by Nitin on 5/26/23.
//

import SwiftUI

struct RideDetailView: View {
    
    var data: Datum?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            
            // app bar at the top
            ZStack(alignment: .leading) {
                
                // button to pop view
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: Constants.Icon.back)
                })

                // title for app bar
                Text("Ride Details")
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical)
            .padding(.bottom)
            
            if let data {
                ScrollView {
                    Text(data.publish.date)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(
                        alignment : .leading,
                        spacing   : 40
                    ) {
                        HStack (alignment: .top) {
                            Text(data.publish.time)
                            // helper layout for city name
                            HStack {
                                LocationTextViewComponent(
                                    icon     : Constants.Icon.startLocation,
                                    location : data.publish.source,
                                    time     : data.publish.source
                                )
                                
                                Spacer()
                                
                                Image(systemName: Constants.Icon.next)
                            }
                        }
                        HStack (alignment: .top) {
                            Text(data.publish.estimateTime ?? "")
                            // helper layout for city name
                            HStack {
                                LocationTextViewComponent(
                                    icon     : Constants.Icon.endLocation,
                                    location : data.publish.destination,
                                    time     : data.publish.destination
                                )
                                
                                Spacer()
                                
                                Image(systemName: Constants.Icon.next)
                            }
                        }
                    }.padding(.horizontal, 2)
                        .overlay (alignment: .leading) {
                            RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                                .frame(width: 2, height: .infinity)
                                .padding(.bottom, 34)
                                .padding(.top, 18)
                                .padding(.leading, 93)
                        }
                        .padding(.bottom)
                    
                    Divider()
                    
                    HStack {
                        Text("Total price for 1 passenger")
                            .font(.system(size: 13))
                        
                        Spacer()
                        
                        Text("\(data.publish.setPrice)")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("data.driverName")
                                .font(.system(size: 16, weight: .semibold))
                            // ratings received by driver
                            HStack (
                                spacing: 4
                            ) {
                                Image(systemName: Constants.Icon.star)
                                    .resizable()
                                    .frame(
                                        width  : 16,
                                        height : 16
                                    )
                                
                                Text("\(4)\\5 - 34 ratings")
                            }
                            .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // driver profile image
                        Image("intro-image")
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width  : 54,
                                height : 54
                            )
                            .clipShape(Circle())
                        
                        Image(systemName: Constants.Icon.next)
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    Button {
                        // contact driver
                    } label: {
                        Text("Contact")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical)

                    Button {
                        // contact driver
                    } label: {
                        Text("Share Ride")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom)
                }
            }
            
        }
        .padding()
        
    }
}

struct RideDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RideDetailView()
    }
}
