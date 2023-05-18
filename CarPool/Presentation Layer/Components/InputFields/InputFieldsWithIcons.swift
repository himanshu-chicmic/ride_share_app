//
//  InputFieldsWithIcons.swift
//  CarPool
//
//  Created by Nitin on 5/18/23.
//

import SwiftUI

struct InputFieldsWithIcons: View {
    
    // MARK: properties
    
    // icon and placeholder fot input field
    var icon: String
    var placeholder: String
    
    @Binding var text: String
    
    // MARK: body
    
    var body: some View {
        HStack{
            
            Image(systemName: icon)
                .foregroundColor(.gray)
            
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
        }
        .padding()
        .background(.gray.opacity(0.05))
        .cornerRadius(4)
        .font(.system(size: 14))
        .onTapGesture {
            //
        }
    }
}

struct InputFieldsWithIcons_Previews: PreviewProvider {
    static var previews: some View {
        InputFieldsWithIcons(
            icon        : Constants.Icon.startLocation,
            placeholder : Constants.Placeholders.leavingFrom,
            text        : .constant(""))
    }
}
