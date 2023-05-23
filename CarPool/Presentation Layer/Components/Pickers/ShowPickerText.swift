//
//  ShowPickerText.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import SwiftUI

/// view to show picker text for various
/// kinds of pickers i.e. date, country, gender, color etc.
struct ShowPickerText: View {
    
    // MARK: - properties
    
    // binding for value
    @Binding var text: String
    // placeholder text
    var placeholder: String
    
    // environment object for userDetailsViewModel
    @EnvironmentObject var userDetailsViewModel: UserDetailsViewModel
    
    // MARK: - body
    var body: some View {
        HStack {
            // text value
            Text(text)
            // set color according to the value
            // if value is same as placeholder
            // keep the color gray
                .foregroundColor(
                    text == placeholder
                    ? .gray.opacity(0.7)
                    : .black
                )
            Spacer()
        }
        .onTapGesture {
            // on tap
            // check the value of placeholder
            // and set the picker type
            // accordingly to open/show the
            // picker of the clicked item
            withAnimation {
                
                switch placeholder {
                case Constants.Placeholders.selectGender:
                    userDetailsViewModel.pickerType = .gender
                case Constants.Vehicle.country:
                    userDetailsViewModel.pickerType = .country
                case Constants.Vehicle.color:
                    userDetailsViewModel.pickerType = .color
                case Constants.Vehicle.modelYear:
                    userDetailsViewModel.pickerType = .modelYear
                default:
                    userDetailsViewModel.pickerType = .date
                }
                
                // toggle show picker
                // to open/show
                userDetailsViewModel.showPicker.toggle()
            }
        }
        .onAppear {
            userDetailsViewModel.showPicker = false
        }
    }
}

struct ShowPickerText_Previews: PreviewProvider {
    static var previews: some View {
        ShowPickerText(
            text: .constant(""), placeholder: ""
        )
        .environmentObject(UserDetailsViewModel())
    }
}
