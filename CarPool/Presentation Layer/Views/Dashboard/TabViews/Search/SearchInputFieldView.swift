//
//  SearchInputFieldView.swift
//  CarPool
//
//  Created by Nitin on 5/26/23.
//

import SwiftUI

struct SearchInputFieldView: View {
    
    // MARK: - properties
    
    // environment variable for dismiss
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    var body: some View {
        VStack {
            
            switch searchViewModel.searchComponentType {
            case .startLocation:
                DrawSearchComponent(
                    heading     : Constants.Headings.pickUp,
                    inputField  : .text,
                    placeholder : Constants.Placeholders.leavingFrom,
                    textField   : $searchViewModel.startLocation
                )
            case .endLocation:
                DrawSearchComponent(
                    heading     : Constants.Headings.dropOff,
                    inputField  : .text,
                    placeholder : Constants.Placeholders.goingTo,
                    textField   : $searchViewModel.endLocation
                )
            case .date:
                DrawSearchComponent(
                    heading     : Constants.Headings.whenAreYouGoing,
                    inputField  : .dateOfBirth,
                    placeholder : Constants.Placeholders.leavingFrom,
                    textField   : .constant("")
                )
            case .numberOfPersons:
                DrawSearchComponent(
                    heading     : Constants.Headings.seatsToBook,
                    inputField  : .text,
                    placeholder : Constants.Placeholders.one,
                    textField   : $searchViewModel.numberOfPersons
                )
            }
            
            // button for saving details
            Button {
                
                withAnimation {
                    // check for textfield validations
                }
                
                // if toast message is empty
                // there no error in validations and verification
                if baseViewModel.toastMessage.isEmpty {
                    searchViewModel.activeSearchView.toggle()
                }
                
            } label: {
                DefaultButtonLabel(text: Constants.Others.save)
            }
            .padding()
            
            Spacer()
        }
        .onChange(of: searchViewModel.activeSearchView) { newValue in
            if !newValue {
                dismiss()
            }
        }
    }
}

struct SearchInputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInputFieldView()
            .environmentObject(SearchViewModel())
            .environmentObject(DetailsViewModel())
            .environmentObject(BaseViewModel())
    }
}
