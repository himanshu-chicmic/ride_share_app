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
    
    // MARK: - body
    
    var body: some View {
        HStack{
            // icon
            Image(systemName: icon)
                .foregroundColor(.gray)
            // text value
            Text(text)
                .frame(
                    maxWidth    : .infinity,
                    alignment   : .leading
                )
                .foregroundColor(.gray)
        }
        .padding()
        .background(.gray.opacity(0.05))
        .cornerRadius(4)
        .font(.system(size: 14))
        .onTapGesture {
            //TODO: activate search view
        }
    }
}

struct InputFieldsWithIcons_Previews: PreviewProvider {
    static var previews: some View {
        InputFieldsWithIcons(
            icon        : Constants.Icon.startLocation,
            placeholder : Constants.Placeholders.leavingFrom,
            text        : .constant("")
        )
    }
}
