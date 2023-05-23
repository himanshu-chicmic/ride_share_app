//
//  GetPickers.swift
//  CarPool
//
//  Created by Himanshu on 5/23/23.
//

import SwiftUI

/// view to show picker according to type
/// of picker received from parent view
struct GetPickers: View {
    
    // MARK: - properties
    
    // type of picker
    var pickerType: PickerType
    // environment object of user details view model
    @EnvironmentObject var userDetailsViewModel: UserDetailsViewModel
    
    // TODO: remove this and add suitable method for a color picker
    @State var color: Color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    // MARK: - body
    
    var body: some View {
        Form {
            // swift for input field type
            switch pickerType {
            // date picker
            case .date:
                DatePicker(
                    "",
                    selection            : $userDetailsViewModel.date,
                    in                   : ...Globals.defaultDate,
                    displayedComponents  : .date
                )
                .datePickerStyle(.graphical)
            // gender picker
            case .gender:
                PickerView(
                    value           : $userDetailsViewModel.gender,
                    selectableValues: Constants.Placeholders.genders,
                    placeholder     : Constants.Placeholders.selectGender
                )
            // country picker
            case .country:
                PickerView(
                    value           : $userDetailsViewModel.country,
                    selectableValues: CountriesList.countries,
                    placeholder     : Constants.Vehicle.country
                )
            // color picker
            case .color:
                ColorPicker("", selection: $color)
            // year picker
            case .modelYear:
                PickerView(
                    value           : $userDetailsViewModel.year,
                    selectableValues: Globals.getYearsList(),
                    placeholder     : Constants.Vehicle.modelYear
                )
            }
        }
    }
}

struct GetPickers_Previews: PreviewProvider {
    static var previews: some View {
        GetPickers(pickerType: .modelYear)
            .environmentObject(UserDetailsViewModel())
    }
}
