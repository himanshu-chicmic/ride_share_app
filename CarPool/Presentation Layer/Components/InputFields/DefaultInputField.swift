//
//  DefaultTextField.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

/// the default input field to be used
/// in the application
struct DefaultInputField: View {
    
    // MARK: - properties
    
    // variable to check the type
    // of input field
    var inputFieldType: InputFieldIdentifier
    // placeholder text for input field
    var placeholder: String
    
    // binding variable for input field
    // value
    @Binding var text: String
    
    // type of keyboard used for
    // input field
    var keyboard: UIKeyboardType
    
    // state var for password visibility
    // true - password is visisble
    // false - password is not visible
    @State var isPasswordVisible: Bool = false

    // environment object for detailsViewModel
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    var background: Color = .gray
    
    // MARK: - body
    
    var body: some View {
        Group {
            
            // swift for input field type
            switch inputFieldType {
                
            case .country:
                ShowPickerText(
                    text        : $detailsViewModel.country,
                    placeholder : Constants.Vehicle.country
                )
            case .color:
                ShowPickerText(
                    text        : $detailsViewModel.color,
                    placeholder : Constants.Vehicle.color
                )
            case .model:
                ShowPickerText(
                    text        : $detailsViewModel.year,
                    placeholder : Constants.Vehicle.modelYear
                )
                
            // text field for date of birth
            // show date picker when tapped
            case .dateOfBirth:
                HStack {
                    Text(
                        Globals
                            .dateFormatter
                            .string(from: detailsViewModel.date)
                    )
                    Spacer()
                }
                .onTapGesture {
                    detailsViewModel.setPickerTypeAndTogglePicker(placeholder: placeholder)
                }
                .onAppear {
                    detailsViewModel.showPicker = false
                }
            
            // show gender text field
            // which on tap shows a gender picker
            case .gender:
                ShowPickerText(
                    text        : $detailsViewModel.gender,
                    placeholder : Constants.Placeholders.selectGender
                )
            
            // show simple text field for
            // email, firstname, lastname and dob
            case .email,
                 .firstName,
                 .lastName,
                 .phoneNumber,
                 .text,
                 .bio:
                TextField(placeholder, text: $text)
            
            // show secure field for
            // password
            case .password,
                 .confirmPassword:
                HStack {
                    // is password is visible
                    // show text field
                    if isPasswordVisible {
                        TextField(placeholder, text: $text)
                    }
                    // if not visible
                    // show secure field
                    else {
                        SecureField(placeholder, text: $text)
                    }
                    
                    // button to toggle password
                    // show/hide
                    Button(action: {
                        isPasswordVisible.toggle()
                    }, label: {
                        Image(
                            systemName: isPasswordVisible
                                        ? Constants.Icon.eye
                                        : Constants.Icon.eyeSlash
                        )
                    })
                }
            }
        }
        .font(.system(size: 15))
        .keyboardType(keyboard)
        .padding()
        .frame(height: 50)
        .background(background.opacity(0.15))
        .cornerRadius(4)
        .padding(.horizontal)
        .overlay {
            // show an overlay
            // when the background color is set to white
            // this overlay adds border to the white background
            // input field
            if background == .white {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(.horizontal)
            }
        }
    }
}

struct DefaultTextField_Previews: PreviewProvider {
    static var previews: some View {
        DefaultInputField(
            inputFieldType : .dateOfBirth,
            placeholder    : Constants.Placeholders.dateOfBirth,
            text           : .constant(""),
            keyboard       : .default
        )
        .environmentObject(DetailsViewModel())
    }
}