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
    var pickerType: PickerFieldIdentifier
    // environment object of user details view model
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    // date range for picker
    var dateRange: ClosedRange<Date>
    @Binding var date: Date
    
    // MARK: - body
    
    var body: some View {
        Form {
            // swift for input field type
            switch pickerType {
            // date picker
            case .date:
                DatePicker(
                    "",
                    selection           : $date,
                    in                  : dateRange,
                    displayedComponents : .date
                )
                .datePickerStyle(.graphical)
            // gender picker
            case .gender:
                PickerView(
                    value            : $detailsViewModel.gender,
                    selectableValues : Constants.Placeholders.genders,
                    placeholder      : Constants.Placeholders.selectGender
                )
            // country picker
            case .country:
                PickerView(
                    value            : $detailsViewModel.country,
                    selectableValues : ListConstants.countries,
                    placeholder      : Constants.Vehicle.country
                )
            // color picker
            case .color:
                PickerView(
                    value            : $detailsViewModel.color,
                    selectableValues : ListConstants.vehicleColors,
                    placeholder      : Constants.Vehicle.color
                )
            // year picker
            case .modelYear:
                PickerView(
                    value            : $detailsViewModel.year,
                    selectableValues : Globals.getYearsList(),
                    placeholder      : Constants.Vehicle.modelYear
                )
            }
        }
    }
}

struct GetPickers_Previews: PreviewProvider {
    static var previews: some View {
        GetPickers(
            pickerType : .modelYear,
            dateRange  : Globals.defaultDateMin...Globals.defaultDate, date: .constant(.now)
        )
        .environmentObject(DetailsViewModel())
    }
}
