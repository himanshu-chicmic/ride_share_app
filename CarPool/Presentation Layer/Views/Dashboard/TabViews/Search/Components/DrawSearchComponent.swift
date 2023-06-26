//
//  DrawSearchComponent.swift
//  CarPool
//
//  Created by Himanshu on 5/26/23.
//

import SwiftUI

struct DrawSearchComponent: View {
    
    // MARK: - properties
    
    // properties for view data
    var heading: String
    var inputField: InputFieldIdentifier
    var placeholder: String
    // binding variable for text field input
    @Binding var textField: String
    
    // environment object for search view model
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    // state object for progress bar view
    @State var showProgressView = false
    
    // MARK: - body
    
    var body: some View {
        VStack {
            
            // app bar at the top
            HStack {
                
                // button to pop view
                Button(action: {
                    // disable search view on close button click
                    searchViewModel.activeSearchView.toggle()
                    // set input field value on view dismiss
                    searchViewModel.setInputFieldValue()
                }, label: {
                    Image(systemName: Constants.Icon.close)
                })
                
                Spacer()
                
            }
            .padding()
            .padding(.bottom)
            
            // title for type of input
            Text(heading)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // set input field type based on the search component type
            // which is updated when this view is opened
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
                    keyboard       : .default
                )
                .lineLimit(1)
                .onChange(of: textField) { text in
                    // call google place api
                    searchViewModel.sendRequestForGettingPlacesData(httpMethod: .GET, requestType: .searchRides, data: text)
                    showProgressView = !text.isEmpty
                }
                .onAppear {
                    // empty search view when this view appears
                    searchViewModel.suggestions = []
                }
                
                // show loader if suggestion list is empty
                if !searchViewModel.suggestions.isEmpty {
                    // list to show suggestions of places
                    List(searchViewModel.suggestions, id: \.self) { suggestion in
                        HStack {
                            // text containg place suggestion
                            Text(suggestion.formattedAddress)
                            Spacer()
                            Image(systemName: Constants.Icon.next)
                                .padding()
                        }
                        .font(.system(size: 14))
                        .onTapGesture {
                            // set text field value to suggestion on tap
                            textField = suggestion.formattedAddress
                            // if search component type is start location then set
                            // start location
                            if searchViewModel.searchComponentType == .startLocation {
                                searchViewModel.startLocationVal = suggestion
                            }
                            // else set value for end location
                            else if searchViewModel.searchComponentType == .endLocation {
                                searchViewModel.endLocationVal = suggestion
                            }
                            // toggle active search view to dismiss this view
                            searchViewModel.activeSearchView.toggle()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .listStyle(.plain)
                } else {
                    // loader will be visible once the text field
                    // containts atleast one character
                    if showProgressView {
                        ProgressView()
                            .padding()
                    }
                }
            }
        }
        .onDisappear {
            showProgressView = false
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
