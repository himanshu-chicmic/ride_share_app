//
//  ToastMessageView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct ToastMessageView: View {
    
    // MARK: - property
    
    // string for validation message
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // MARK: - body
    
    var body: some View {
        HStack{
            Text(signInViewModel.toastMessage)
            Spacer()
            Button {
                withAnimation {
                    signInViewModel.toastMessage = ""
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
        .background(.red.opacity(0.75))
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding()
    }
}

struct ToastMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ToastMessageView()
            .environmentObject(SignInViewModel())
    }
}
