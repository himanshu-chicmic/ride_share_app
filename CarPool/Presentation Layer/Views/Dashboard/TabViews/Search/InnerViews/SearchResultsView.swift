//
//  SearchResultsView.swift
//  CarPool
//
//  Created by Nitin on 5/26/23.
//

import SwiftUI

struct RidesListData: Hashable {
    var startLocation = "Chandigarh"
    var endLocation = "Patiala"
    var startTime = "03:00 am"
    var endTime = "04:00 am"
    var price: String
    var dateOfDeparture = "Friday may 23"
    var numberOfSeats = "2"
    var driverImage = Constants.Images.introImage
    var driverName = "Driver"
    var driverRating = "4.8"
}

struct SearchResultsView: View {
    
    @State var selectedTile: RidesListData = RidesListData(price: "")
    @State var nagitate = false
    
    @Environment(\.dismiss) var dismiss
    
    var list = [RidesListData(price: "3000 Rs."), RidesListData(price: "300 Rs."), RidesListData(price: "3300 Rs."), RidesListData(price: "3050 Rs."), RidesListData(price: "300 Rs."), RidesListData(price: "3300 Rs."), RidesListData(price: "3050 Rs.")]
    
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
            .padding()
            
            ScrollView {
                ForEach(list, id: \.self) { data in
                    RidesListItem(
                        startLoction:data.startLocation,
                        startTime: data.startTime,
                        endLocation: data.endLocation,
                        endTime: data.endTime,
                        price: data.price,
                        dateOfDeparture: "Fri May 26",
                        numberOfSeats: "2",
                        driverImage: Constants.Images.introImage,
                        driverName: "Driver",
                        driverRating: "4.8")
                    .foregroundColor(.black)
                    .onTapGesture {
                        selectedTile = data
                        nagitate.toggle()
                    }
                }
                .navigationDestination(isPresented: $nagitate) {
                    RideDetailView(data: selectedTile)
                        .navigationBarBackButtonHidden()
                }
                .padding()
                
            }
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}
