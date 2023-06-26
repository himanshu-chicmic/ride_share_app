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
                            Text("Find a ride")
                                .padding(.vertical, 12)
                                .padding(.horizontal, 44)
                                .background(findRide ? Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)) : .gray.opacity(0.05))
                                .foregroundColor(findRide ? .white : .gray)
                            Text("Offer a ride")
                                .padding(.vertical, 12)
                                .padding(.horizontal, 44)
                                .background(!findRide ? Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)) : .gray.opacity(0.05))
                                .foregroundColor(!findRide ? .white : .gray)
                        }
                        .cornerRadius(100)
                        .onTapGesture {
                            withAnimation {
                                findRide.toggle()
                            }
                        }
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
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<2) { index in
                                Text("Don't make advance payments to driver to avoid any inconveniences.")
                                    .padding(.vertical, 24)
                                    .padding(.horizontal, 44)
                                    .background(colorsListForBanners[index])
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, design: .rounded))
                                    .fontWeight(.medium)
                                    .frame(width: 360)
                                    .cornerRadius(4)
                                    .padding(.leading, ((index == 0) ? 16 : 0))
                                    .padding(.trailing, ((index == 1) ? 16 : 0))
                            }
                        }
                    }
                    .scrollIndicators(.never)
                    .padding(.vertical)
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundColor(.gray.opacity(0.05))
                        .background(.gray.opacity(0.05))
                    
                    Text("Recent Searches")
                        .font(.system(size: 16, design: .rounded))
                        .fontWeight(.medium)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(0..<5) { index in
                                RidesListItem(
                                    startLoction    : "Chandigarh, Punjab",
                                    startTime       : "08:00 AM",
                                    endLocation     : "Mohali, Punjab",
                                    endTime         : "09:00 AM",
                                    date            : "",
                                    price           : "",
                                    driverImage     : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMWare6bVn8jvzemzQAGlNCznq2mhogai21DA4EHHoEKfvUFbFOru20v7L3BHZD2CghQTuHaxLdGk&usqp=CAU&ec=48665701",
                                    driverName      : "Miles Morales",
                                    driverRating    : "4.9/5.0"
                                )
                                .frame(width: 300)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    searchViewModel.showRideDetailView.toggle()
                                }
                                .padding(.leading, ((index == 0) ? 16 : 0))
                                .padding(.trailing, ((index == 4) ? 16 : 0))
                            }
                        }
                    }
                    .scrollIndicators(.never)
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
            
            // toast message for errors
            if !baseViewModel.toastMessage.isEmpty {
                ToastMessageView()
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
