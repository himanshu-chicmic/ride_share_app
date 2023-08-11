//
//  TextArea.swift
//  CarPool
//
//  Created by Himanshu on 8/10/23.
//

import SwiftUI

struct MessageInput: View {
    
    @State var inputText: String = ""
    @State var disableSendButton = true
    
    var data: Chat
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
        HStack {
            
            TextField("Type your message...", text: $inputText)
                .padding()
                .background(.gray.opacity(0.05))
                .cornerRadius(1000)
                .font(.system(size: 15))
                .keyboardType(.default)
                .onChange(of: inputText) { newValue in
                    withAnimation {
                        disableSendButton = inputText.isEmpty
                    }
                }
            
            
            if !disableSendButton {
                Button(action: {
                    chatViewModel.createChatApiCall(httpMethod: .POST, requestType: .chatMessages, data: ["id": data.id, "message": ["content" : inputText, "receiver_id" : data.receiverID]])
                    // on success
                    inputText = ""
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .padding()
                        .background(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                        .foregroundColor(.white)
                        .cornerRadius(1000)
                })
            }
            
        }
        .padding(.horizontal)
    }
}
