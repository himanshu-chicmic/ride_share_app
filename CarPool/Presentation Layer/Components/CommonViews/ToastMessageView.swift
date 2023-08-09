//
//  ToastMessageView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

/// message box used to show any error,
/// success, or warning messages
struct ToastMessageView: View {
    
    // MARK: - properties
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // MARK: - body
    
    var body: some View {
        HStack {
            // message text
            Text(baseViewModel.toastMessage)
            Spacer()
            // button to dismiss
            Button {
                withAnimation {
                    baseViewModel.toastMessage = ""
                }
            } label: {
                Image(systemName: Constants.Icon.close)
                    .foregroundColor(.white)
            }
            .padding(4)

        }
        .font(.system(size: 12))
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(baseViewModel.toastMessageBackground)
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding()
    }
}

struct ToastMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ToastMessageView()
            .environmentObject(BaseViewModel())
    }
}
