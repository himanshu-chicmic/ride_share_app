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
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    var userID: Int {
        guard let id = baseViewModel.userData?.status.data?.id else {
            return 0
        }
        return id
    }
    
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
                        if let publish = data.publish {
                            MessagesListItem(image: (userID != data.receiverID ? data.receiverImage : data.senderImage) ?? "", name: userID != data.receiverID ? "\(data.receiver.firstName) \(data.receiver.lastName)" : "\(data.sender.firstName) \(data.sender.lastName)", pickupLocation: publish.source, dropLocation: publish.destination)
                                .onTapGesture {
                                    chatViewModel.createChatApiCall(httpMethod: .GET, requestType: .chatMessages, data: ["id": data.id])
                                    chatViewModel.openChatView.toggle()
                                    selectedTile = data
                                }
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
                .refreshable {
                    chatViewModel.createChatApiCall(httpMethod: .GET, requestType: .chatRooms, data: [:])
                }
            } else {
                Spacer()
                PlaceholderView(image: Constants.EmptyRidesView.image, title: Constants.EmptyInboxView.title, caption: Constants.EmptyInboxView.caption)
                Spacer()
            }
        }.onAppear {
            if BaseViewModel.shared.switchToDashboard {
                chatViewModel.createChatApiCall(httpMethod: .GET, requestType: .chatRooms, data: [:])
            }
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
            .environmentObject(ChatViewModel())
    }
}
