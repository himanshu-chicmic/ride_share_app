//
//  InboxView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct InboxView: View {
    
    // data of selected result
    @State var selectedTile: Chat?
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            // app icon
            Text("Messages")
                .font(.system(size: 18, design: .rounded))
                .fontWeight(.medium)
                .padding()
            
            Divider()
            
            
            if !chatViewModel.chatData.isEmpty {
                
                ScrollView {
                    ForEach($chatViewModel.chatData, id: \.self) { $data in
                        MessagesListItem(image: Constants.EmptyRidesView.image, name: "\(data.receiver.firstName) \(data.receiver.lastName)", pickupLocation: data.publish.source, dropLocation: data.publish.destination)
                            .onTapGesture {
                                chatViewModel.openChatView.toggle()
                                selectedTile = data
                            }
                    }
                    .navigationDestination(isPresented: $chatViewModel.openChatView) {
                        if let selectedTile {
                            ChatView(data: selectedTile)
                                .navigationBarBackButtonHidden()
                        }
                    }
                    .padding()
                }
            } else {
                Spacer()
                PlaceholderView(image: Constants.EmptyRidesView.image, title: Constants.EmptyInboxView.title, caption: Constants.EmptyInboxView.caption)
                Spacer()
            }
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
