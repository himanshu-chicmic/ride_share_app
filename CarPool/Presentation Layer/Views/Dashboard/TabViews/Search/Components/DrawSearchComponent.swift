//
//  DrawSearchComponent.swift
//  CarPool
//
//  Created by Himanshu on 5/26/23.
//

import SwiftUI

struct DrawSearchComponent: View {
    
    // MARK: - properties
    
    var heading: String
    var inputField: InputFieldIdentifier
    var placeholder: String
    
    // text field input
    @Binding var textField: String
    
    // search view model
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    @StateObject var locationViewModel = LocationViewModel()
    
    // MARK: - body
    
    var body: some View {
        VStack {
            
            // app bar
            HStack {
                
                // close button
                Button(action: {
                    searchViewModel.activeSearchView.toggle()
                    searchViewModel.setInputFieldValue()
                }, label: {
                    Image(systemName: Constants.Icon.close)
                })
                
                Spacer()
                
            }
            .padding()
            .padding(.bottom)
            
            // title
            Text(heading)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // input field
            switch searchViewModel.searchComponentType {
            case .date:
                DatePicker(
                    "",
                    selection           : $searchViewModel.dateOfDeparture,
                    in                  : Formatters.defaultDateCurrent...Formatters.defaultDateMax,
                    displayedComponents : searchViewModel.findRide ? .date : [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                .padding()
            case .numberOfPersons:
                StepperInputField()
            case .vehicle:
                List(
                    baseViewModel.vehiclesData?.status.data ?? [],
                    id: \.self
                ) {
                    VehicleTextView(data: $0)
                }
                .listStyle(.plain)
                .onChange(of: textField) { newValue in
                    if newValue.isEmpty {
                        textField = Constants.Placeholders.vehicle
                    }
                }
            default:
                DefaultInputField(
                    inputFieldType : inputField,
                    placeholder    : placeholder,
                    text           : $textField,
                    keyboard       : placeholder == Constants.Placeholders.price ? .numberPad : .default
                )
                .lineLimit(1)
                .onChange(of: textField) { text in
                    if searchViewModel.searchComponentType != .price {
                        searchViewModel.sendRequestForGettingPlacesData(httpMethod: .GET, requestType: .searchRides, data: text)
                    } else {
                        if text.count > 5 {
                            textField = String(text.prefix(5))
                        }
                    }
                }
                .onAppear {
                    searchViewModel.suggestions = []
                }
                
                // show loader if suggestion list is empty
                if !searchViewModel.suggestions.isEmpty && searchViewModel.searchComponentType != .price {
                    List(searchViewModel.suggestions, id: \.self) { suggestion in
                        HStack {
                            Image(systemName: Constants.Icon.mapMark)
                                .padding(.trailing)
                            Text(suggestion.formattedAddress)
                            Spacer()
                            Image(systemName: Constants.Icon.next)
                                .padding()
                        }
                        .font(.system(size: 14))
                        .onTapGesture {
                            // set text field value to suggestion on tap
                            textField = suggestion.formattedAddress
                            // if search component type is start location
                            if searchViewModel.searchComponentType == .startLocation {
                                searchViewModel.startLocationVal = suggestion
                            }
                            // else set value for end location
                            else if searchViewModel.searchComponentType == .endLocation {
                                searchViewModel.endLocationVal = suggestion
                            }
                            
                            searchViewModel.updateRecents(dataRecentSearches: suggestion)
                            searchViewModel.activeSearchView.toggle()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .listStyle(.plain)
                } else {
                    if searchViewModel.showProgressView {
                        ProgressView()
                            .padding()
                    }
                }
                
                // search history is not empty
                if searchViewModel.searchComponentType != .price && !searchViewModel.showProgressView && searchViewModel.suggestions.isEmpty && !searchViewModel.searchHistory.isEmpty {
                    
                    List(searchViewModel.searchHistory, id: \.self) { suggestion in
                        HStack {
                            HStack {
                                Image(systemName: Constants.Icon.history)
                                    .padding(.trailing)
                                Text(suggestion.formattedAddress)
                            }
                            .onTapGesture {
                                // set text field value to suggestion on tap
                                textField = suggestion.formattedAddress
                                // if search component type is start location
                                if searchViewModel.searchComponentType == .startLocation {
                                    searchViewModel.startLocationVal = suggestion
                                }
                                // else set value for end location
                                else if searchViewModel.searchComponentType == .endLocation {
                                    searchViewModel.endLocationVal = suggestion
                                }
                                
                                searchViewModel.activeSearchView.toggle()
                            }
                            Spacer()
                            Image(systemName: Constants.Icon.close)
                                .padding()
                                .onTapGesture {
                                    searchViewModel.updateRecents(dataRecentSearches: suggestion, delete: true)
                                }
                        }
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .listStyle(.plain)
                }
            }
            Spacer()
        }
        .overlay (alignment: .bottomTrailing) {
            if searchViewModel.searchComponentType == .startLocation {
                HStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: Constants.Icon.location)
                            .foregroundColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                            .padding([.vertical, .leading])
                            .padding(.trailing, searchViewModel.showProgressView ? 18 : 0)
                        
                        if !searchViewModel.showProgressView {
                            Text(Constants.Others.currentLocation)
                                .fontWeight(.light)
                                .padding(.trailing)
                        }
                    }
                    .font(.system(size: 13))
                    .background(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary, alpha: 0.15)))
                    .cornerRadius(8)
                    .padding()
                    .onTapGesture {
                        locationViewModel.checkPermissionAndGetLocation()
                    }
                }
            }
        }
        .onChange(of: locationViewModel.currentLocation, perform: { newValue in
            if searchViewModel.searchComponentType == .startLocation {
                searchViewModel.startLocation = newValue
                locationViewModel.stopLocationUpdation()
            }
        })
        .onDisappear {
            searchViewModel.showProgressView = false
            locationViewModel.stopLocationUpdation()
        }
    }
}

struct DrawSearchComponent_Previews: PreviewProvider {
    static var previews: some View {
        DrawSearchComponent(
            heading     : "",
            inputField  : .text,
            placeholder : "",
            textField   : .constant("")
        )
        .environmentObject(SearchViewModel())
        .environmentObject(BaseViewModel())
    }
}
