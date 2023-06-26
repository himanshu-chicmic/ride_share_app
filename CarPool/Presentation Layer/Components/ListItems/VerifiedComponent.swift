//
//  VerifiedComponent.swift
//  CarPool
//
//  Created by Nitin on 6/2/23.
//

import SwiftUI

struct VerifiedComponent: View {
    
    var icon: String
    var text: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            // plus circle image
            Image(systemName: Constants.Icon.checkCircle)
                .foregroundColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
            
            Text(text)
                .font(.system(size: 17))
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
        }
    }
}

struct VerifiedComponent_Previews: PreviewProvider {
    static var previews: some View {
        VerifiedComponent(icon: Constants.Icon.check, text: "abc")
    }
}
