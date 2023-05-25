//
//  ProfileView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - properties
    
    // state variable to get the current tab
    @State var currentTab = 0
        
    // MARK: - body
    
    var body: some View {

        VStack(spacing: 0) {
            
            // top bar for changing
            // the tab views
            HStack {
                Group {
                    // about view
                    Text(Constants.ProfileButtons.about)
                        .onTapGesture {
                            withAnimation {
                                currentTab = 0
                            }
                        }
                    
                    // account view
                    Text(Constants.ProfileButtons.account)
                        .onTapGesture {
                            withAnimation {
                                currentTab = 1
                            }
                        }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .fontWeight(.semibold)
            .overlay(
                alignment: currentTab == 0
                ? .bottomLeading
                : .bottomTrailing
            ) {
                // overlay for bottom line
                // that indicates which tab
                // is currenlty active
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: 210)
            }
            
            // tab views for about and account
            TabView(selection: $currentTab) {
                
                // profile about view
                ProfileTabViewAbout()
                    .tag(0)
                
                // profile account view
                ProfileTabViewAccount()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
