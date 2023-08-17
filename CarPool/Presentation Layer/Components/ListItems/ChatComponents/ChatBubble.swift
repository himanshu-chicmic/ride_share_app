//
//  ChatBubble.swift
//  CarPool
//
//  Created by Himanshu on 8/8/23.
//

import SwiftUI

struct ChatBubble: View {
    
    var isReceived: Bool
    var message: String
    var time: String
    
    var colorBgSender: Color = Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary))
    var colorFgSender: Color = .white
    var colorBgReciver: Color = Color(uiColor: UIColor(hexString: Constants.DefaultColors.secondary))
    var colorFgReciver: Color = .black
    
    var body: some View {
        VStack(alignment: isReceived ? .leading : .trailing, spacing: 4) {
            ZStack (alignment: isReceived ? .bottomLeading : .bottomTrailing) {
                
                Rectangle()
                    .foregroundColor(isReceived ? colorBgReciver : colorBgSender)
                    .frame(width: 18, height: 18)
                
                Text(message)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(isReceived ? colorBgReciver : colorBgSender)
                    .foregroundColor(isReceived ? colorFgReciver : colorFgSender)
                    .cornerRadius(20)
            }
            
            Text(time)
                .font(.system(size: 9))
                .fontWeight(.light)
                .foregroundColor(.gray)
            
        }
        .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
        .padding(.horizontal)
        .padding(isReceived ? .trailing : .leading, 64)
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(isReceived: false, message: "I drive!!!", time: "00:00 am")
    }
}
