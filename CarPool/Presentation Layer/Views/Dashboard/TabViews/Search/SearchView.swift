//
//  SearchView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - properties
    
    // environment objects
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
        
    // data of selected result
    @State var selectedTile: Datum?
    
    @State var ridePublishConfirmation: Bool = false
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack (alignment: .leading) {
                
                // app icon
                HStack (alignment: .center) {
                    
                    Image(Constants.Images.carpoolIcon)
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(Constants.Onboarding.rideShare)
                        .font(.system(size: 18, design: .rounded))
                        .fontWeight(.medium)
                }
                .padding()
                
                Divider()
                
                ScrollView {
                    // switch `find a ride` and `offer a ride`
                    HStack {
                        Group {
                            Text(Constants.Search.findARide)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 44)
                                .background(searchViewModel.findRide ? Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)) : .gray.opacity(0.05))
                                .foregroundColor(searchViewModel.findRide ? .white : .gray)
                                .onTapGesture {
                                    withAnimation {
                                        searchViewModel.findRide = true
                                        searchViewModel.resetData()
                                    }
                                }
                            Text(Constants.Search.offerARide)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 44)
                                .background(!searchViewModel.findRide ? Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)) : .gray.opacity(0.05))
                                .foregroundColor(!searchViewModel.findRide ? .white : .gray)
                                .onTapGesture {
                                    withAnimation {
                                        searchViewModel.findRide = false
                                        searchViewModel.resetData()
                                    }
                                }
                        }
                        .cornerRadius(100)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    
                    VStack {
                        // departure
                        InputFieldsWithIcons(
                            icon        : Constants.Icon.startLocation,
                            placeholder : Constants.Placeholders.leavingFrom,
                            text        : $searchViewModel.startLocation,
                            inputType   : .startLocation
                        )
                        .padding(.horizontal)
                        
                        // destination
                        InputFieldsWithIcons(
                            icon        : Constants.Icon.endLocation,
                            placeholder : Constants.Placeholders.goingTo,
                            text        : $searchViewModel.endLocation,
                            inputType   : .endLocation
                        )
                        .padding(.horizontal)
                    }.overlay(alignment: .trailing) {
                        Button {
                            withAnimation {
                                searchViewModel.swapStartEndLocation()
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .padding(.trailing, 34)
                    }
                    
                    HStack {
                        // date
                        InputFieldsWithIcons(
                            icon        : Constants.Icon.calendar,
                            placeholder : Constants.Placeholders.today,
                            text        : .constant(""),
                            inputType   : .date
                        )
                        // number of persons
                        InputFieldsWithIcons(
                            icon        : Constants.Icon.person,
                            placeholder : String(Constants.Placeholders.one),
                            text        : $searchViewModel.numberOfPersons,
                            inputType   : .numberOfPersons
                        )
                        
                    }
                    .padding(.horizontal)
                    
                    if !searchViewModel.findRide {
                        // vehicle
                        InputFieldsWithIcons(
                            icon        : Constants.Icon.car,
                            placeholder : Constants.Placeholders.vehicle,
                            text        : $searchViewModel.selectedVehicle,
                            inputType   : .vehicle
                        )
                        .padding(.horizontal)
                        .onAppear {
                            if baseViewModel.vehiclesData?.status.data == [] {
                                searchViewModel.selectedVehicle = ""
                            }
                        }
                        
                        // price
                        InputFieldsWithIcons(
                            icon        : Constants.Icon.rupee,
                            placeholder : Constants.Placeholders.price,
                            text        : $searchViewModel.pricePerSeat,
                            inputType   : .price
                        )
                        .padding(.horizontal)
                        
                    }
                    
                    // search rides
                    Button(action: {
                        searchViewModel.callApiMethods()
                    }, label: {
                        Text(searchViewModel.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            // set background by checking `isPrimary` boolean
                            .background(
                                Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary))
                            )
                            // set foreground by checking `isPrimary` boolean
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    })
                    .padding(.vertical, 24)
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.05))
                        .background(.gray.opacity(0.05))
                    
                    if !searchViewModel.recenltyViewedRides.isEmpty {
                        
                        HStack(alignment: .center) {
                            Text(Constants.Search.recentlyViewed)
                                .font(.system(size: 16, design: .rounded))
                                .fontWeight(.medium)
                                .padding()
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    UserDefaults.standard.set([], forKey: Constants.UserDefaultKeys.recentViewedRides)
                                    searchViewModel.getRecentlyViewed(key: Constants.UserDefaultKeys.recentViewedRides)
                                }
                            } label: {
                                Text(Constants.Others.clear)
                                    .font(.system(size: 14, design: .rounded))
                                    .fontWeight(.medium)
                                    .padding()
                            }
                            
                        }
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(Array(zip(searchViewModel.recenltyViewedRides.indices, searchViewModel.recenltyViewedRides)), id: \.0) { (index, recentSearch) in
                                    RidesListItem(
                                        startLoction    : recentSearch.publish.source,
                                        startTime       : Formatters.getFormattedDate(date: recentSearch.publish.time),
                                        endLocation     : recentSearch.publish.destination,
                                        endTime         : Formatters.getFormattedDate(date: recentSearch.reachTime),
                                        date            : "\(recentSearch.publish.date ?? Constants.Placeholders.defaultTime)",
                                        price           : Formatters.getPrice(price: Int(recentSearch.publish.setPrice)),
                                        driverImage     : recentSearch.imageURL ?? "",
                                        driverName      : recentSearch.name,
                                        driverRating    : Formatters.getRatings(ratings: recentSearch.averageRating ?? 0)
                                    )
                                    .frame(width: 300)
                                    .foregroundColor(.black)
                                    .padding(.leading, ((index == 0) ? 16 : 0))
                                    .padding(.trailing, ((index == searchViewModel.recenltyViewedRides.count-1) ? 16 : 0))
                                    .onTapGesture {
                                        selectedTile = recentSearch
                                        searchViewModel.showRideDetailViewFromRecents.toggle()
                                        baseViewModel
                                            .sendVehiclesRequestToApi(
                                                httpMethod: .GET, requestType: .getVehicleById, data: [Constants.JsonKeys.id: recentSearch.publish.vehicleID!]
                                        )
                                    }
                                }
                                .navigationDestination(isPresented: $searchViewModel.showRideDetailViewFromRecents) {
                                    if let selectedTile {
                                        RideDetailView(data: selectedTile)
                                            .navigationBarBackButtonHidden()
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.never)
                    }
                }
                .scrollIndicators(.never)
                
            }
            .onChange(of: searchViewModel.activeSearchView) { _ in
                searchViewModel.suggestions = []
            }
            .navigationDestination(isPresented: $searchViewModel.showSearchResults, destination: {
                SearchResultsView()
                    .navigationBarBackButtonHidden()
            })
            .navigationDestination(isPresented: $searchViewModel.openMapView, destination: {
                VStack {
                    // app bar at the top
                    ZStack(alignment: .leading) {
                        
                        // button to pop view
                        Button(action: {
                            searchViewModel.openMapView.toggle()
                        }, label: {
                            Image(systemName: Constants.Icon.back)
                        })
                        
                        // title of app bar
                        Text(Constants.Search.route)
                        .frame(maxWidth: .infinity)
                        
                    }
                    .padding()
                    
                    Divider()
                    
                    ZStack (alignment: .bottom) {
                        GoogleMapView()
                            .ignoresSafeArea()
                        
                        Button(action: {
                            ridePublishConfirmation.toggle()
                        }, label: {
                            Text(searchViewModel.buttonText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                            // set background by checking `isPrimary` boolean
                                .background(
                                    Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary))
                                )
                            // set foreground by checking `isPrimary` boolean
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        })
                        .padding(.vertical, 24)
                        .padding(.horizontal)
                    }
                    .confirmationDialog(
                        "Are you sure to publish this ride?",
                        isPresented     : $ridePublishConfirmation,
                        titleVisibility : .visible
                    ) {
                        Button("Publish", role: .none) {
                            searchViewModel.callApiForPublish()
                        }
                    }
                }
                .navigationBarBackButtonHidden()
            })
            // search input field
            .fullScreenCover(isPresented: $searchViewModel.activeSearchView) {
                SearchInputFieldView()
            }
            // ride book success
            .fullScreenCover(isPresented: $searchViewModel.bookedSuccess) {
                RideBookSuccess()
            }
            
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(BaseViewModel())
            .environmentObject(SearchViewModel())
    }
}
