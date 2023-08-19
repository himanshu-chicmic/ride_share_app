//
//  EditPublishedRide.swift
//  CarPool
//
//  Created by Nitin on 8/9/23.
//

import SwiftUI

struct EditPublishedRide: View {
    
    // MARK: - properties
    
    // environment objects
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var openMap: Bool = false
    
    var data: Publish?
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack (alignment: .leading) {
                
                // app bar
                ZStack(alignment: .leading) {

                    // title for app bar
                    Text(Constants.Headings.editRide)
                        .frame(maxWidth: .infinity)
                    
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: Constants.Icon.back)
                        })
                        
                        Spacer()
                        
                        // update button
                        Button {
                            openMap.toggle()
                        }
                        label: {
                           Text(Constants.Others.update)
                       }
                    }
                }
                .padding()

                Divider()
                
                ScrollView {
                    
                    // departure
                    InputFieldsWithIcons(
                        icon        : Constants.Icon.startLocation,
                        placeholder : Constants.Placeholders.leavingFrom,
                        text        : $searchViewModel.startLocation,
                        inputType   : .startLocation
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    
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
                    
                    // vehicle
                    InputFieldsWithIcons(
                        icon        : Constants.Icon.car,
                        placeholder : Constants.Placeholders.vehicle,
                        text        : $searchViewModel.selectedVehicle,
                        inputType   : .vehicle
                    )
                    .padding(.horizontal)
                    
                    // price
                    InputFieldsWithIcons(
                        icon        : Constants.Icon.rupee,
                        placeholder : Constants.Placeholders.price,
                        text        : $searchViewModel.pricePerSeat,
                        inputType   : .price
                    )
                    .padding(.horizontal)
                }
                .scrollIndicators(.never)
                
            }
            .onChange(of: searchViewModel.activeSearchView) { _ in
                searchViewModel.suggestions = []
            }
            // search input field
            .fullScreenCover(isPresented: $searchViewModel.activeSearchView) {
                SearchInputFieldView()
            }
            .fullScreenCover(isPresented: $openMap) {
                VStack {
                    // app bar at the top
                    ZStack(alignment: .leading) {
                        
                        // button to pop view
                        Button(action: {
                            if searchViewModel.openMapView {
                                searchViewModel.openMapView.toggle()
                            } else {
                                openMap.toggle()
                            }
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
                        GoogleMapView(data: data)
                            .ignoresSafeArea()
                        
                        Button(action: {
                            if let data {
                                searchViewModel.updateRideDetails(httpMethod: .PUT, requestType: .updateRide, data: data.getDictData(delegate: searchViewModel))
                                openMap.toggle()
                            }
                        }, label: {
                            Text("Update")
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
                }
            }
            .onAppear {
                searchViewModel.findRide = false
                searchViewModel.startLocation = data?.source ?? ""
                searchViewModel.endLocation = data?.destination ?? ""
                searchViewModel.dateOfDeparture = Formatters.dateFormatter.date(from: "\(String(describing: data?.date)) \(String(describing: data?.time))" ) ?? .now
                searchViewModel.numberOfPersons = "\(String(describing: data?.passengersCount ?? 1))"
                
                if let data = baseViewModel.singleVehicleData?.status.data?.first {
                    searchViewModel.selectedVehicle = "\(data.vehicleName) - \(data.vehicleBrand)"
                }
                
                searchViewModel.pricePerSeat = "\(String(describing: data?.setPrice ?? 0))"
            }
            
        }
    }
}

struct EditPublishedRide_Previews: PreviewProvider {
    static var previews: some View {
        EditPublishedRide()
            .environmentObject(BaseViewModel())
            .environmentObject(SearchViewModel())
    }
}
