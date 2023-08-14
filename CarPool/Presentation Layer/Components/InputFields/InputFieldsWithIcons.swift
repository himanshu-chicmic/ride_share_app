//
//  InputFieldsWithIcons.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI

/// struct view to create input fields with icons
/// no text field is used in this view
/// it's only used for search function in this ap
/// where no text fields are required
struct InputFieldsWithIcons: View {
    
    // MARK: - properties
    
    // icon and placeholder fot input field
    var icon: String
    var placeholder: String
    
    // binding variable for text in the field
    @Binding var text: String
    
    // variable for search input type
    var inputType: SearchInputsIdentifier
    
    // search view model environment object
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var foregroundColor: Color {
        switch inputType {
        case .startLocation, .endLocation, .price, .vehicle:
            return text.isEmpty ? .gray : .black
        case .date, .numberOfPersons:
            return .black
        }
    }
    
    // MARK: - body
    
    var body: some View {
        HStack {
            // icon
            Image(systemName: icon)
                .foregroundColor(.gray)
            // text value
            Text(inputType == .date ? Formatters.dateFormatter.string(from: searchViewModel.dateOfDeparture) : text.isEmpty ? placeholder : text)
                .frame(
                    maxWidth  : .infinity,
                    alignment : .leading
                )
                .foregroundColor(foregroundColor)
                .lineLimit(1)
        }
        .padding()
        .background(.gray.opacity(0.05))
        .cornerRadius(4)
        .font(.system(size: 14))
        .onTapGesture {
            searchViewModel.searchComponentType = inputType
            searchViewModel.activeSearchView.toggle()
        }
    }
}

struct InputFieldsWithIcons_Previews: PreviewProvider {
    static var previews: some View {
        InputFieldsWithIcons(
            icon        : Constants.Icon.startLocation,
            placeholder : Constants.Placeholders.leavingFrom,
            text        : .constant(""),
            inputType   : .startLocation
        )
        .environmentObject(SearchViewModel())
    }
}
