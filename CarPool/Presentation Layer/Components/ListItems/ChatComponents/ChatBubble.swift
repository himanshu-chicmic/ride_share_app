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
    var time: String = "12:00 pm"
    
    var body: some View {
        VStack(alignment: isReceived ? .leading : .trailing, spacing: 4) {
            ZStack (alignment: isReceived ? .bottomLeading : .bottomTrailing) {
                
                Rectangle()
                    .foregroundColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                    .frame(width: 18, height: 18)
                
                Text(message)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            
            Text(time)
                .font(.system(size: 9))
                .fontWeight(.light)
                .foregroundColor(.gray)
            
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble()
    }
}
