//
//  AddProfileOptionView.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import SwiftUI

/// view for adding single details item in the data
struct AddProfileOptionView: View {
    
    // MARK: - properties
    
    // environment object for dismiss the view
    @Environment(\.dismiss) var dismiss
    
    // environment object of validations view model
    @EnvironmentObject var validationsViewModel: ValidationsViewModel
    
    // text field variable
    @State var textField: String = ""
    // title heading for text field
    var heading: String
    // placeholder text for text field
    var placeholder: String
    // type of input field
    var inputField: InputFieldIdentifier
    // keyboard type
    var keyboardType: UIKeyboardType
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack{
                
                // app bar at the top
                ZStack (alignment: .leading){
                    
                    // button to pop view
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: Constants.Icon.close)
                    })
                    
                    // title of app bar
                    Text(Constants.UserInfo.title)
                    .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                Text(heading)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // text field for user input
                DefaultInputField(
                    inputFieldType  : inputField,
                    placeholder     : placeholder,
                    text            : $textField,
                    keyboard        : keyboardType
                )

                // button for saving details
                Button {
                    
                    withAnimation{
                        // check for textfield validations
                        validationsViewModel.toastMessage = validationsViewModel
                            .validationsInstance
                            .validateTextFields(
                                textFields: [(
                                    textField,
                                    placeholder,
                                    inputField,
                                    keyboardType
                                )]
                            )
                        
                        // check for verification
                    }
                    
                    // if toast message is empty
                    // there no error in validations and verification
                    if validationsViewModel.toastMessage.isEmpty {
                        // set new password
                        // if new password is set
                        // then dismiss the view
                        dismiss()
                    }
                    else {
                        // if any error is shown
                        // show if for 3 seconds and
                        // then make it disappear
                        DispatchQueue.main.asyncAfter(deadline: .now()+3){
                            validationsViewModel.toastMessage = ""
                        }
                    }
                    
                } label: {
                    DefaultButtonLabel(text: Constants.LogIn.submit)
                }
                .padding()
                
                // space to occupy extra space
                Spacer()
            }
            
            // show toast message
            // if any validation or verificatioin
            // message exists
            if !validationsViewModel.toastMessage.isEmpty {
                ToastMessageView()
            }
        }
    }
}

struct AddProfileOptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileOptionView(
            heading     : "",
            placeholder : "",
            inputField  : .email,
            keyboardType: .default
        )
        .environmentObject(ValidationsViewModel())
    }
}
