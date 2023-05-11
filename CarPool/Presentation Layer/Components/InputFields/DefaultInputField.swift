//
//  DefaultTextField.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

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
    
//    @Binding var showDatePicker: Bool
//    @Binding var showGenderPicker: Bool
    
    // MARK: - body
    
    var body: some View {
        Group{
            
            // swift for input field type
            switch inputFieldType {
                
                case .dateOfBirth :
                    TextField(placeholder, text: $text)
                    .onTapGesture {
//                        showDatePicker.toggle()
                    }
                
                case .gender :
                    TextField(placeholder, text: $text)
                    .onTapGesture {
//                        showGenderPicker.toggle()
                    }
                
                // show simple text field for
                // email, firstname, lastname and dob
                case .email,
                     .firstName,
                     .lastName:
                    TextField(placeholder, text: $text)
                
                // show secure field for
                // password
                case .password,
                     .confirmPassword:
                    HStack{
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
        .background(.gray.opacity(0.15))
        .cornerRadius(4)
        .padding(.horizontal)
    }
}

struct DefaultTextField_Previews: PreviewProvider {
    static var previews: some View {
        DefaultInputField(inputFieldType: .dateOfBirth, placeholder: Constants.Placeholders.dateOfBirth, text: .constant(""), keyboard: .default)
    }
}
