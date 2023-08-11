//
//  ChatView.swift
//  CarPool
//
//  Created by Himanshu on 8/10/23.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    var data: Chat?
    
    var body: some View {
        VStack {
            if let data {
                
                ChatViewTopBar(name: "\(data.receiver.firstName) \(data.receiver.lastName)", userType: "Driver", dateAndTime: "\(Formatters.getLongDate(date: data.publish.date ?? Constants.Placeholders.defaultTime)) at \(Formatters.getFormattedDate(date: data.publish.time))", pickupLocation: data.publish.source, dropLocation: data.publish.destination)
                
                ScrollViewReader { value in
                    ScrollView (showsIndicators: false) {
                        HStack {
                            Image(systemName: "info.circle")
                            
                            Text("Do not make advance payments to the driver.")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.system(size: 12))
                        .padding()
                        .foregroundColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                        .padding(.bottom, 34)
                        
                        ForEach($chatViewModel.chatMessages, id: \.self) { $message in
                            ChatBubble(isReceived: data.senderID != message.senderID, message: message.content, time: Formatters.getFormattedDate(date: message.updatedAt))
                                .id(message.id)
                        }
                        .onAppear{
                            value.scrollTo(chatViewModel.chatMessages.last?.id, anchor: .bottom)
                        }
                        .onChange(of: chatViewModel.chatMessages.count) { newValue in
                            withAnimation {
                                value.scrollTo(chatViewModel.chatMessages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: baseViewModel.keyboardHeight) { newValue in
                        withAnimation {
                            value.scrollTo(chatViewModel.chatMessages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            if let data  {
                if data.publish.status != "cancelled" {
                    MessageInput(data: data)
                        .padding(.bottom, 8)
                }
            }
        }
        .onAppear {
            if let data {
                chatViewModel.createChatApiCall(httpMethod: .GET, requestType: .chatMessages, data: ["id": data.id])
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
