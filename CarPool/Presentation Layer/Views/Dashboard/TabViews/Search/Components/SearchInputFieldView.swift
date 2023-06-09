//
//  SearchInputFieldView.swift
//  CarPool
//
//  Created by Himanshu on 5/26/23.
//

import SwiftUI

struct SearchInputFieldView: View {
    
    // MARK: - properties
    
    // environment objects
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    // MARK: - body
    
    var body: some View {
        VStack {
            // type of search
            switch searchViewModel.searchComponentType {
            case .startLocation:
                DrawSearchComponent(
                    heading     : Constants.Headings.pickUp,
                    inputField  : .text,
                    placeholder : Constants.Placeholders.inputLocation,
                    textField   : $searchViewModel.startLocation
                )
            case .endLocation:
                DrawSearchComponent(
                    heading     : Constants.Headings.dropOff,
                    inputField  : .text,
                    placeholder : Constants.Placeholders.inputLocation,
                    textField   : $searchViewModel.endLocation
                )
            case .price:
                DrawSearchComponent(
                    heading     : Constants.Headings.pricePerSeat,
                    inputField  : .text,
                    placeholder : Constants.Placeholders.price,
                    textField   : $searchViewModel.pricePerSeat
                )
            case .vehicle:
                DrawSearchComponent(
                    heading     : Constants.Headings.vehicle,
                    inputField  : .text,
                    placeholder : Constants.Placeholders.vehicle,
                    textField   : $searchViewModel.selectedVehicle
                )
            case .date:
                DrawSearchComponent(
                    heading     : Constants.Headings.whenAreYouGoing,
                    inputField  : .dateOfBirth,
                    placeholder : "",
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
            
            if searchViewModel.searchComponentType == .numberOfPersons || searchViewModel.searchComponentType == .date || searchViewModel.searchComponentType == .price {
                // button for saving details
                Button {
                    searchViewModel.activeSearchView.toggle()
                } label: {
                    DefaultButtonLabel(text: Constants.Others.save)
                }
                .padding()
            }
            
            Spacer()
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
