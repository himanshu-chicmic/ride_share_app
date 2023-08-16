//
//  SplashView.swift
//  CarPool
//
//  Created by Himanshu on 8/16/23.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        // ride share logo
        VStack {
            Image(Constants.Images.carpoolIcon)
                .resizable()
                .frame(width: 94, height: 94)
            Text(Constants.Onboarding.rideShare)
                .font(.system(size: 20, design: .rounded))
                .fontWeight(.semibold)
                .opacity(0.9)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
