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
