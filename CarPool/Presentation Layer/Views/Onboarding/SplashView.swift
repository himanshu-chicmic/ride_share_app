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
        VStack (spacing: 0) {
            Image(Constants.Images.carpoolIcon)
                .resizable()
                .frame(width: 54, height: 54)
            Text(Constants.Onboarding.rideShare)
                .font(.system(size: 20, design: .rounded))
                .fontWeight(.bold)
        }
        .padding(34)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
