//
//  CircleProgressView.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import SwiftUI

/// progress bar view for showing
/// process or loading action
struct CircleProgressView: View {
    
    // MARK: - properties

    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // MARK: - body
    
    var body: some View {
    
        // show progress view if inProgress in
        // baseViewModel is set to true
        if baseViewModel.inProgess {
            VStack {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            .background(.gray.opacity(0.25))
        }
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView()
            .environmentObject(BaseViewModel())
    }
}
