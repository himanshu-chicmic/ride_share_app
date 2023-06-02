//
//  DrawSearchComponent.swift
//  CarPool
//
//  Created by Nitin on 5/26/23.
//

import SwiftUI

struct DrawSearchComponent: View {
    
    // MARK: - properties
    
    var heading: String
    var inputField: InputFieldIdentifier
    var placeholder: String

    @Binding var textField: String
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    // MARK: - body
    
    var body: some View {
        VStack {
            
            // app bar at the top
            HStack {
                
                // button to pop view
                Button(action: {
                    searchViewModel.activeSearchView.toggle()
                }, label: {
                    Image(systemName: Constants.Icon.close)
                })
                
                Spacer()
                
            }
            .padding()
            .padding(.bottom)
            
            Text(heading)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            switch searchViewModel.searchComponentType {
            case .date:
                DatePicker(
                    "",
                    selection           : $searchViewModel.dateOfDeparture,
                    in                  : Globals.defaultDateCurrent...Globals.defaultDateMax,
                    displayedComponents : .date
                )
                .datePickerStyle(.graphical)
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
                    searchViewModel.sendRequestToApi(httpMethod: .GET, requestType: .searchRides, data: text)
                }
                
                List(searchViewModel.suggestions, id: \.self) { suggestion in
                    ZStack {
                        Text(suggestion.formattedAddress)
                            .onTapGesture {
                                textField = suggestion.formattedAddress
                                
                                if searchViewModel.searchComponentType == .startLocation {
                                    searchViewModel.startLocationVal = suggestion
                                } else if searchViewModel.searchComponentType == .endLocation {
                                    searchViewModel.endLocationVal = suggestion
                                }
                                
                                searchViewModel.activeSearchView.toggle()
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                .listStyle(.plain)
            }
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
