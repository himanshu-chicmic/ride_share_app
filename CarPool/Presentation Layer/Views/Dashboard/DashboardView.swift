//
//  DashboardView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct DashboardView: View {
    
    // MARK: - properties
    
    // state
    @State var tabViewData: [TabViewIdentifier] = [
        .search, .rides, .inbox, .profile
    ]
    @State private var selection = TabViewIdentifier.search
    
    // state objects
    @StateObject var searchViewModel = SearchViewModel()
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // MARK: - body
    
    var body: some View {
        
        // tab bar view
        NavigationStack {
            TabView(selection: $selection) {
                ForEach(tabViewData, id: \.self) { value in
                    Group {
                        // tab views
                        switch value {
                        case .search  : SearchView()
                        case .rides   : YourRidesView()
                        case .inbox   : InboxView()
                        case .profile : ProfileView()
                        }
                    }
                    .padding(.bottom)
                    // tab item
                    .tabItem {
                        Image(systemName: value.rawValue.image)
                            .foregroundColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                        Text(value.rawValue.text)
                    }
                    .tag(value)
                }
            }
        }
        .environmentObject(searchViewModel)
        .overlay {
            CircleProgressView()
        }
        
        .overlay (alignment: .bottom) {
            // toast message for validation or errors
            if !baseViewModel.toastMessage.isEmpty {
                ToastMessageView()
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
