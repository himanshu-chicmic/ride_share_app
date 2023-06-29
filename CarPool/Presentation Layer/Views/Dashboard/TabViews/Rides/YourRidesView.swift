//
//  YourRidesView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct YourRidesView: View {
    
    // MARK: - properties
    
    // state variable to get the current tab
    @State var currentTab = 0
    
    // state variable for alignment of bottom line
    // on the tab bars
    @State var lineAlignment: Alignment = .bottomLeading
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    // MARK: - body
    
    var body: some View {

        VStack(spacing: 0) {
            
            // top bar for changing
            // the tab views
            HStack {
                Group {
                    // about view
                    Text(Constants.RidesData.booked)
                        .onTapGesture {
                            withAnimation {
                                currentTab = 0
                            }
                        }
                    
                    // account view
                    Text(Constants.RidesData.published)
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
                
                // if no data in inbox
                BookedRidesView()
                    .tag(0)
                
                // profile account view
                
                // if no data in inbox
                PublishedRidesView()
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

struct YourRidesView_Previews: PreviewProvider {
    static var previews: some View {
        YourRidesView()
    }
}
