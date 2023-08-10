//
//  ChatView.swift
//  CarPool
//
//  Created by Himanshu on 8/10/23.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        VStack {
            ChatViewTopBar(name: "Arjun Singh", userType: "Driver", dateAndTime: "15 May, 2023, 12:30 pm", pickupLocation: "Meerut", dropLocation: "Gurgaon")
            
            ScrollView {
                
                HStack {
                    
                    Image(systemName: "info.circle")
                    
                    Text("Do not make advance payments to the driver.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(size: 12))
                .padding()
                .foregroundColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                
                Text("Today")
                    .font(.system(size: 13))
                    .opacity(0.5)
                    .padding(.top, 34)
                
                ChatBubble(isReceived: false, message: "hi", time: "12:00 am")
                ChatBubble(isReceived: true, message: "hiiiiiiiiiiyeryeryeyeeryeyyertertertertertertetrtretrtertetetrttertetertrterreterttrtertei", time: "12:00 am")
                
            }
            
            MessageInput()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
