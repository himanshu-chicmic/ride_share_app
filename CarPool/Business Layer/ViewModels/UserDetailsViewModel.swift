//
//  UserDetailsViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation
import SwiftUI
import Combine

class UserDetailsViewModel: ObservableObject {
    
    // MARK: - properties
    
    // picker variables
    @Published var showPicker = false
    @Published var pickerType: PickerType = .date
    
    private var cancellables: AnyCancellable?
    
    // varible to get response from api
    @Published var getResponse: SignInLogInModel?
    
    // variable to store date
    // set the default date by
    // difference of 18 years from now
    @Published var date: Date = Globals.defaultDate
    // variable to store gender
    @Published var gender: String = Constants.Placeholders.selectGender
    
    // published var to store vehicle
    // related details from pickers
    @Published var country: String = Constants.Vehicle.country
    @Published var color: String = Constants.Vehicle.color
    @Published var year: String = Constants.Vehicle.modelYear
    
    // progress value for profile completion
    // increments by 30 points
    @Published var profileCompletion = 0.0
    
    // property to get the index value
    // from profileCompletion state var
    // this index is used to get the value
    // from titles array in Constants
    var index: Int {
        Int(profileCompletion/Constants.UserDetails.progressIncrements) - 1
    }
    
    // userDetailsModel for first name,
    // last name, date of birth and,
    // gender properties
    @Published var userDetailsModel = UserDetailsModel()
    
    // state array to store the values
    // neccessary for the input fields
    @Published var textFieldValues: [Constants.TypeAliases.InputFieldArrayType] = []
    
    // instance for validations view model
    var validationsViewModel = ValidationsViewModel.shared
    
    // MARK: - methods
    
    /// method to reset text fields array
    func resetTextFields() {
        textFieldValues = userDetailsModel.getInputFields2dArray()
    }
    
    func validateProfileData(increment: Bool, emailPassword: Constants.TypeAliases.InputFieldArrayType) {
        withAnimation {
            
            // check validations while incrementing
            // the complete profile steps
            
            // check for name
            if profileCompletion == 30 && increment {
                // check for textfield validations
                validationsViewModel.toastMessage = validationsViewModel
                    .validationsInstance
                    .validateTextFields(
                        textFields: textFieldValues[index]
                    )
            }
            
            // check for gender
            else if profileCompletion == 90 && increment {
                // check for name prefix validations
                validationsViewModel.toastMessage = validationsViewModel
                    .validationsInstance
                    .validatePickerSelectedValue(
                        value: gender,
                        placeholder: Constants.Placeholders.selectGender,
                        error: Constants.ValidationMessages.invalidNamePrefix
                    )
            }
            
            // increment button is pressed
            if increment {
                // check if toast message empty
                // and compeltion value's between 30 and 90
                if validationsViewModel.toastMessage.isEmpty
                   && profileCompletion >= 30 && profileCompletion < 90 {
                    // then increment
                    profileCompletion += 30
                } else if validationsViewModel.toastMessage.isEmpty && profileCompletion == 90 {
                    // call signin method
                    callApi(
                        httpMethod      : .POST,
                        requestType     : .signUp,
                        emailPassword   : emailPassword
                    )
                }
                
            } else {
                // when decrement button (back) is pressed
                profileCompletion -= 30
            }
            
        }
    }
    
    /// method to call sign in api for creating user
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func callApi(httpMethod: HttpMethod, requestType: RequestType, emailPassword: Constants.TypeAliases.InputFieldArrayType? = []) {
        // set in progress to true for showing loader
        validationsViewModel.inProgess = true
        
        // set data for sending
        var data: [String: Any] = [:]
        // set endpoint for api
        var endPoint = ApiConstants.commonEndpoint

        // switch over request type
        // to set data variable with correct
        // values and set endpoints based on
        // the type of request
        switch requestType {
        case .signUp:
            data = userDetailsModel.getData(
                emailPassword   : emailPassword!,
                values          : textFieldValues,
                viewModel       : self
            )
        case .getDetails:
            break
        case .logOut:
            endPoint = ApiConstants.signOut
        default:
            break
        }
        
        // call signInUserMethod in ApiManager class
        cancellables = ApiManager.shared.signInUser(
            httpMethod      : httpMethod,
            dataDictionary  : data,
            endPoint        : endPoint,
            requestType     : requestType
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                self.validationsViewModel.toastMessage = error.localizedDescription
                print("ERROR: \(error.localizedDescription)")
            case .finished:
                print("success")
            }
            
            self.validationsViewModel.disableProgress()
        } receiveValue: { [weak self] data in
            self?.getResponse = data
            print(data)
            switch requestType {
            case .signUp:
                self?.validationsViewModel.dismiss = true
                self?.validationsViewModel.goToDashboard()
            default:
                break
            }
        }
    }
    
    /// method to reset properties
    /// associated with date and gender pickers
    func resetPickerData() {
        profileCompletion = 0.0
        showPicker = false
        date = Globals.defaultDate
        gender = Constants.Placeholders.selectGender
        country = Constants.Vehicle.country
        color = Constants.Vehicle.color
        year = Constants.Vehicle.modelYear
    }
    
}
