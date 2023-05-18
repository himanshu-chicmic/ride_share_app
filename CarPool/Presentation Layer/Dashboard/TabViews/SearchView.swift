//
//  SearchView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: properties
    
    // search view model
    @State var searchViewModel = SearchViewModel()
    
    // MARK: body
    
    var body: some View {
        VStack{
            Text(Constants.Search.title)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .padding(.bottom)
            
            InputFieldsWithIcons(
                icon        : Constants.Icon.startLocation,
                placeholder : Constants.Placeholders.leavingFrom,
                text        : $searchViewModel.startLocation
            )
            
            InputFieldsWithIcons(
                icon        : Constants.Icon.endLocation,
                placeholder : Constants.Placeholders.goingTo,
                text        : $searchViewModel.endLocation
            )
            
            HStack {
                
                InputFieldsWithIcons(
                    icon        : Constants.Icon.calendar,
                    placeholder : Constants.Placeholders.today,
                    text        : $searchViewModel.dateOfDeparture
                )
                
                InputFieldsWithIcons(
                    icon        : Constants.Icon.person,
                    placeholder : String(Constants.Placeholders.one),
                    text        : $searchViewModel.numberOfPersons
                )
                
                
            }
            
            Button(action: {
                // go to search page
            }, label: {
                DefaultButtonLabel(text: Constants.Search.search)
            })
            .padding(.vertical)
        }
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
