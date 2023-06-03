//
//  SearchView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - properties
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                Spacer()
                
                Text(Constants.Search.title)
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                InputFieldsWithIcons(
                    icon        : Constants.Icon.startLocation,
                    placeholder : Constants.Placeholders.leavingFrom,
                    text        : $searchViewModel.startLocation,
                    inputType   : .startLocation
                )
                
                InputFieldsWithIcons(
                    icon        : Constants.Icon.endLocation,
                    placeholder : Constants.Placeholders.goingTo,
                    text        : $searchViewModel.endLocation,
                    inputType   : .endLocation
                )
                
                HStack {
                    
                    InputFieldsWithIcons(
                        icon        : Constants.Icon.calendar,
                        placeholder : Constants.Placeholders.today,
                        text        : .constant(""),
                        inputType   : .date
                    )
                    
                    InputFieldsWithIcons(
                        icon        : Constants.Icon.person,
                        placeholder : String(Constants.Placeholders.one),
                        text        : $searchViewModel.numberOfPersons,
                        inputType   : .numberOfPersons
                    )
                    
                }
                
                Button(action: {
                    searchViewModel.validateSearchInput()
                }, label: {
                    DefaultButtonLabel(text: Constants.Search.search)
                })
                .padding(.vertical)
                
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $searchViewModel.activeSearchView) {
                SearchInputFieldView()
            }
            .onChange(of: searchViewModel.activeSearchView) { _ in
                searchViewModel.suggestions = []
            }
            .navigationDestination(isPresented: $searchViewModel.showSearchResults, destination: {
                SearchResultsView()
                    .navigationBarBackButtonHidden()
            })
            
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
    }
}
