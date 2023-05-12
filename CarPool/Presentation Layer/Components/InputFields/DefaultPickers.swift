//
//  DefaultPickeres.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct DefaultPickers: View {
    
    // MARK: - properties
    
    // environment object for signInViewModel
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // MARK: - body
    
    var body: some View {
        VStack (alignment: .trailing){
            
            // button to dismiss the picker
            Button(action: {
                
                // toggle the boolean value to dismiss
                // picker and assign the final value
                // to text binding
                
                // if date picker is shown
                if signInViewModel.showDatePicker {
                    signInViewModel.showHideDatePicker(show: false)
                }
                // if gender picker is shown
                else if signInViewModel.showGenderPicker {
                    signInViewModel.showHideGenderPicker(show: false)
                }
                
            }, label: {
                // button label
                Text(Constants.Others.done)
            })

            Group{
                // show date picker when showDatePicker
                // is set to true
                if signInViewModel.showDatePicker {
                    DatePicker(
                        "",
                        selection            : $signInViewModel.date,
                        in                   : ...Date.now,
                        displayedComponents  : .date
                    )
                    .datePickerStyle(.wheel)
                }
                // show gender picker when showGenderPicker
                // is set to true
                else if signInViewModel.showGenderPicker {
                    Picker(
                        "",
                        selection: $signInViewModel.gender
                    ) {
                        ForEach(Constants.Placeholders.genders, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                    .onChange(of: signInViewModel.gender) { value in
                        if value.isEmpty{
                            signInViewModel.gender = Constants.Placeholders.selectGender
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
            .environmentObject(SignInViewModel())
    }
}
