//
//  ProfileView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - properties
    
    @State var currentTab = 0
    
    @State var lineAlignment: Alignment = .bottomLeading
        
    // MARK: - body
    
    var body: some View {

        VStack(spacing: 0) {
            
            // tab bar
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
            .overlay(alignment: lineAlignment) {
                // tab bar bottom line
                Rectangle()
                    .frame(height: 1)
                    .frame(maxWidth: 210)
            }
            
            // tab views
            TabView(selection: $currentTab) {
                
                // profile about
                ProfileTabViewAbout()
                    .tag(0)
                
                // profile account
                ProfileTabViewAccount()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: currentTab) { value in
                withAnimation {
                    if value == 1 {
                        lineAlignment = .bottomTrailing
                    } else {
                        lineAlignment = .bottomLeading
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
