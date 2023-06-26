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
    
    @StateObject var locationViewModel = LocationViewModel()
    
    // progress bar view
    @State var showProgressView = false
    
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
                    in                  : Globals.defaultDateCurrent...Globals.defaultDateMax,
                    displayedComponents : .date
                )
                .datePickerStyle(.graphical)
                .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                .padding()
            case .numberOfPersons:
                StepperInputField()
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
                        // call google place api
                        searchViewModel.sendRequestForGettingPlacesData(httpMethod: .GET, requestType: .searchRides, data: text)
                        withAnimation {
                            showProgressView = !text.isEmpty
                        }
                    } else {
                        if text.rangeOfCharacter(from: NSCharacterSet.decimalDigits) == nil {
                            textField = ""
                        }
                        
                        if text.count > 5 {
                            textField = String(text.prefix(5))
                        }
                    }
                }
                .onAppear {
                    searchViewModel.suggestions = []
                }
                
                // show loader if suggestion list is empty
                if !searchViewModel.suggestions.isEmpty {
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
                            
                            searchViewModel.updateRecentSearched(data: suggestion, delete: false)
                            
                            searchViewModel.activeSearchView.toggle()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .listStyle(.plain)
                } else {
                    if showProgressView {
                        ProgressView()
                            .padding()
                    }
                }
                
                // search history is not empty
                if searchViewModel.searchComponentType != .price && !showProgressView && searchViewModel.suggestions.isEmpty && !searchViewModel.searchHistory.isEmpty {
                    
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
                                    searchViewModel.updateRecentSearched(data: suggestion, delete: true)
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
                            .padding(.trailing, showProgressView ? 18 : 0)
                        
                        if !showProgressView {
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
                        switch locationViewModel.authorizationStatus {
                        case .authorizedAlways, .authorizedWhenInUse:
                            locationViewModel.startLocationUpdation()
                        default:
                            locationViewModel.requestPermission()
                        }
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
            showProgressView = false
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
    }
}
