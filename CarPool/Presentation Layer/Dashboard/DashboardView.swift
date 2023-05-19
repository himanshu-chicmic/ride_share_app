//
//  DashboardView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct DashboardView: View {
    
    // MARK: - properties
    
    // state array for tableview identifier
    // used for displaying tab bar
    @State var tabViewData: [TabViewIdentifier] = [
        .search, .rides, .inbox, .profile
    ]
    
    // state var for selection of tab item
    @State private var selection = TabViewIdentifier.search
    
    // MARK: - body
    
    var body: some View {
        
        // tab view
        NavigationStack {
            TabView(selection: $selection) {
                // loop over array  to display all
                // the five tabs
                ForEach(tabViewData, id: \.self) { value in
                    
                    Group{
                        // root of of tab
                        switch value {
                            case .search    : SearchView()
                            case .rides     : YourRidesView()
                            case .inbox     : InboxView()
                            case .profile   : ProfileView()
                        }
                    }
                    // associated tab item
                    .tabItem {
                        Image(systemName: value.rawValue.image)
                        Text(value.rawValue.text)
                    }
                    .tag(value)
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
