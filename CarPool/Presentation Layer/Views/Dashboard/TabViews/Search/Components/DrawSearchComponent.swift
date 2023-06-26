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
                    keyboard       : .default
                )
                .lineLimit(1)
                .onChange(of: textField) { text in
                    // call google place api
                    searchViewModel.sendRequestForGettingPlacesData(httpMethod: .GET, requestType: .searchRides, data: text)
                    showProgressView = !text.isEmpty
                }
                .onAppear {
                    searchViewModel.suggestions = []
                }
                
                // show loader if suggestion list is empty
                if !searchViewModel.suggestions.isEmpty {
                    List(searchViewModel.suggestions, id: \.self) { suggestion in
                        HStack {
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
