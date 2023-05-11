//
//  UserDetailsView.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct UserDetailsView: View {
    
    // MARK: - properties
    
    // userDetailsModel for first name,
    // last name, date of birth and,
    // gender properties
    var userDetailsModel = UserDetailsModel()
    
    // state array to store the values
    // neccessary for the input fields
    @State var textFieldValues: [Constants.TypeAliases.InputFieldArrayType] = []
    
    // progress value for profile completion
    // increments by 30 points
    @State private var profileCompletion = 0.0
    
    // property to get the index value
    // from profileCompletion state var
    // this index is used to get the value
    // from titles array in Constants
    private var index: Int {
        Int(profileCompletion/Constants.UserDetails.progressIncrements) - 1
    }
    
    // environment variable to dismiss the view
    @Environment(\.dismiss) var dismiss
    
//    // variable to store date
//    @State var date: Date = Date.now
//    @State var gender: String = ""
//
//    // picker variables
//    @State var showDatePicker = false
//    @State var showGenderPicker = false
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack{
                
                // app bar at the top
                ZStack (alignment: .leading){
                    
                    // button to pop view
                    Button(action: {
                        // navigate back
                        // dismiss after asking a confirmation
                        // after dismiss don't go to
                        // sign up page
                        // got to home view instead
                        dismiss()
                    }, label: {
                        Image(systemName: Constants.Icon.back)
                    })
                    
                    // title for app bar
                    Text(Constants.UserDetails.title)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .padding(.bottom)
                
                // progress bar
                ProgressView(
                    String(format: Constants.UserDetails.progress, index+1),
                    value   : profileCompletion,
                    total   : Constants.UserDetails.progressCompletion
                )
                .padding()
                .font(.system(size: 13))
                
                // if profileCompletion value is greater
                // than 0 then show the content of this page
                if profileCompletion > 0 {
                    
                    // title
                    Text(Constants.UserDetails.titles[index])
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // for each loop to put
                    // input fields to the view
                    // the for each loop works for the 2d array textFieldValue[[]]
                    // which contains necessary information of the fields to add
                    ForEach($textFieldValues[index].indices, id: \.self) { i in
                        DefaultInputField(
                            inputFieldType  : textFieldValues[index][i].2,
                            placeholder     : textFieldValues[index][i].1,
                            text            : $textFieldValues[index][i].0,
                            keyboard        : textFieldValues[index][i].3
                        )
                    }
                    
                    // button for back and continue
                    // complete profile steps
                    HStack{
                        if index > 0 {
                            // back button
                            BackAndContinueButtons(
                                completion  : $profileCompletion,
                                increment   : false
                            )
                        }
                        // continue button
                        BackAndContinueButtons(
                            completion  : $profileCompletion,
                            increment   : true
                        )
                    }
                    .padding()
                    
                }
                
                // spacer to occupy extra space
                Spacer()
            }
            .onAppear{
                // increase the profile completion with +30 increment
                // to set the first step for complete profile
                profileCompletion += Constants.UserDetails.progressIncrements
                
                // populate text field values
                // array when the view appears
                textFieldValues = userDetailsModel.getInputFields()
        }
            
//            if showDatePicker {
//                VStack (alignment: .trailing){
//
//                    Button(action: {
//                        withAnimation{
//                            showDatePicker.toggle()
//                        }
//                    }, label: {
//                        Text("Done")
//                    })
//
//                    DatePicker(
//                        "",
//                        selection            : $date,
//                        in                   : ...Date.now,
//                        displayedComponents  : .date
//                    )
//                    .datePickerStyle(.wheel)
//                    .labelsHidden()
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.horizontal)
//            }
//
//            if showGenderPicker {
//                Picker("", selection: $gender) {
//                    ForEach(Constants.Placeholders.gender, id: \.self) {
//                        Text($0)
//                            .font(.system(size: 15))
//                    }
//                }
//                .pickerStyle(.wheel)
//            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
    }
}
