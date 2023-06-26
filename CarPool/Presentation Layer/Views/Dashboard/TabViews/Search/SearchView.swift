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
    
    // state variables
    @State var findRide: Bool = true
    
    // data of selected result
    @State var selectedTile: Datum?
    
    // colors array
    private var colorsListForBanners: [Color] = [
        Color(uiColor: UIColor(hexString: "#9699BE")),
        Color(uiColor: UIColor(hexString: "#90BAA8"))
    ]
    
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
                                .background(findRide ? Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)) : .gray.opacity(0.05))
                                .foregroundColor(findRide ? .white : .gray)
                                .onTapGesture {
                                    withAnimation {
                                        findRide = true
                                    }
                                }
                            Text(Constants.Search.offerARide)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 44)
                                .background(!findRide ? Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)) : .gray.opacity(0.05))
                                .foregroundColor(!findRide ? .white : .gray)
                                .onTapGesture {
                                    withAnimation {
                                        findRide = false
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
                    
                    if findRide {
                        // date
                        GetPickers(pickerType: .vehicle, dateRange: Globals.defaultDateMin...Globals.defaultDate, date: .constant(.now))
                        .padding()
                        
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
                        searchViewModel.validateSearchInput()
                    }, label: {
                        Text(Constants.Search.search)
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
                                        startTime       : Globals.getFormattedDate(date: recentSearch.publish.time),
                                        endLocation     : recentSearch.publish.destination,
                                        endTime         : Globals.getFormattedDate(date: recentSearch.reachTime),
                                        date            : "\(recentSearch.publish.date ?? Constants.Placeholders.defaultTime)",
                                        price           : Globals.getPrice(price: recentSearch.publish.setPrice),
                                        driverImage     : recentSearch.imageURL ?? "",
                                        driverName      : recentSearch.name,
                                        driverRating    : Globals.getRatings(ratings: recentSearch.averageRating ?? 0)
                                    )
                                    .frame(width: 300)
                                    .foregroundColor(.black)
                                    .padding(.leading, ((index == 0) ? 16 : 0))
                                    .padding(.trailing, ((index == searchViewModel.recenltyViewedRides.count-1) ? 16 : 0))
                                    .onTapGesture {
                                        selectedTile = recentSearch
                                        searchViewModel.showRideDetailView.toggle()
                                    }
                                }
                                .navigationDestination(isPresented: $searchViewModel.showRideDetailView) {
                                    RideDetailView(data: selectedTile ?? nil)
                                        .navigationBarBackButtonHidden()
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
