//
//  ChatBubble.swift
//  CarPool
//
//  Created by Nitin on 8/8/23.
//

import SwiftUI

struct ChatBubble: View {
    
    var isReceived: Bool = false
    var message: String = "hey !!!!"
    
    var body: some View {
        ZStack (alignment: isReceived ? .bottomLeading : .bottomTrailing) {
            
            Text(message)
                .font(.system(size: 14))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                .foregroundColor(.white)
                .cornerRadius(24)
            
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                .frame(width: 20, height: 20)
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble()
    }
}
