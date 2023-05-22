//
//  DefaultPickeres.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

/// default picker for application
/// contains date and gender picker
/// the picker are styled as wheel type
struct DefaultPickers: View {
    
    // MARK: - properties
    
    // environment object for signInViewModel
    @EnvironmentObject var userDetailsViewModel: UserDetailsViewModel
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .trailing) {
            
            // button to dismiss the picker
            Button(action: {
                
                // toggle the boolean value to dismiss
                // picker and assign the final value
                // to text binding
                
                // if date picker is shown
                if userDetailsViewModel.showDatePicker {
                    userDetailsViewModel.showHideDatePicker(show: false)
                }
                // if gender picker is shown
                else if userDetailsViewModel.showGenderPicker {
                    userDetailsViewModel.showHideGenderPicker(show: false)
                }
                // if country picker is shown
                else if userDetailsViewModel.showCountryPicker {
                    withAnimation {
                        userDetailsViewModel.showCountryPicker = false
                    }
                }
                // if color picker is shown
                else if userDetailsViewModel.showColorPicker {
                    withAnimation {
                        userDetailsViewModel.showColorPicker = false
                    }
                }
                // if year picker is shown
                else if userDetailsViewModel.showYearPicker {
                    withAnimation {
                        userDetailsViewModel.showYearPicker = false
                    }
                }
                
            }, label: {
                // button label
                Text(Constants.Others.done)
                    .padding(.top)
            })

            Group {
                // show date picker when showDatePicker
                // is set to true
                if userDetailsViewModel.showDatePicker {
                    DatePicker(
                        "",
                        selection            : $userDetailsViewModel.date,
                        in                   : ...Globals.defaultDate,
                        displayedComponents  : .date
                    )
                    .datePickerStyle(.wheel)
                }
                // show gender picker when showGenderPicker
                // is set to true
                else if userDetailsViewModel.showGenderPicker {
                    Picker(
                        "",
                        selection: $userDetailsViewModel.gender
                    ) {
                        ForEach(
                            Constants.Placeholders.genders,
                            id: \.self
                        ) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                    .onChange(of: userDetailsViewModel.gender) { value in
                        if value.isEmpty {
                            userDetailsViewModel.gender = Constants.Placeholders.selectGender
                        }
                    }
                } else if userDetailsViewModel.showCountryPicker {
                    Picker(
                        "",
                        selection: $userDetailsViewModel.country
                    ) {
                        ForEach(
                            CountriesList.countries,
                            id: \.self
                        ) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                    .onChange(of: userDetailsViewModel.country) { value in
                        if value.isEmpty {
                            userDetailsViewModel.country = Constants.Vehicle.country
                        }
                    }
                } else if userDetailsViewModel.showColorPicker {
                    ColorPicker("Set the background color", selection: $userDetailsViewModel.color, supportsOpacity: false)
                    .onChange(of: userDetailsViewModel.color) { value in
                        if value.isEmpty {
                            userDetailsViewModel.country = Constants.Vehicle.country
                        }
                    }
                }
            }
            .labelsHidden()
        }
        .frame(maxWidth: .infinity)
    }
}

struct DefaultPickeres_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPickers()
            .environmentObject(UserDetailsViewModel())
    }
}
