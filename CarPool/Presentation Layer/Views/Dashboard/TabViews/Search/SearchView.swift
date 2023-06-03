//
//  SearchView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - properties
    
    // environment objects for base view model and search view model
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                Spacer()
                
                // title
                Text(Constants.Search.title)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                // select departure location
                InputFieldsWithIcons(
                    icon        : Constants.Icon.startLocation,
                    placeholder : Constants.Placeholders.leavingFrom,
                    text        : $searchViewModel.startLocation,
                    inputType   : .startLocation
                )
                
                // select destination location
                InputFieldsWithIcons(
                    icon        : Constants.Icon.endLocation,
                    placeholder : Constants.Placeholders.goingTo,
                    text        : $searchViewModel.endLocation,
                    inputType   : .endLocation
                )
                
                HStack {
                    // select date
                    InputFieldsWithIcons(
                        icon        : Constants.Icon.calendar,
                        placeholder : Constants.Placeholders.today,
                        text        : .constant(""),
                        inputType   : .date
                    )
                    // select number of persons
                    InputFieldsWithIcons(
                        icon        : Constants.Icon.person,
                        placeholder : String(Constants.Placeholders.one),
                        text        : $searchViewModel.numberOfPersons,
                        inputType   : .numberOfPersons
                    )
                    
                }
                
                // action button to search rides
                Button(action: {
                    // call validate search input to validate data in text fields
                    searchViewModel.validateSearchInput()
                }, label: {
                    DefaultButtonLabel(text: Constants.Search.search)
                })
                .padding(.vertical)
                
                Spacer()
            }
            .padding()
            // view full screen cover for search active state
            // to input data in fields
            .fullScreenCover(isPresented: $searchViewModel.activeSearchView) {
                SearchInputFieldView()
            }
            // on change of search view model's activeSearchView
            // empty search suggestions that are displayed when user input a city
            // or place to get the desired location
            .onChange(of: searchViewModel.activeSearchView) { _ in
                searchViewModel.suggestions = []
            }
            // navigation destination to show search results in
            // search results view page
            .navigationDestination(isPresented: $searchViewModel.showSearchResults, destination: {
                SearchResultsView()
                    .navigationBarBackButtonHidden()
            })
            
            // show toast if any error is thrown
            if !baseViewModel.toastMessage.isEmpty {
                ToastMessageView()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(BaseViewModel())
            .environmentObject(SearchViewModel())
    }
}
