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
    
    @Environment(\.dismiss) var dismiss
    
    var userID: Int {
        guard let id = baseViewModel.userData?.status.data?.id else {
            return 0
        }
        return id
    }
    
    var checkReceiver: (Message) -> Bool {
        { message in
            if userID == data.senderID {
                return data.senderID != message.senderID
            }
            if userID == data.receiverID {
                return data.senderID != message.receiverID
            }
            return false
        }
    }
    
    var name: String {
        if userID != data.receiverID {
            return "\(data.receiver.firstName) \(data.receiver.lastName)"
        }
        return "\(data.sender.firstName) \(data.sender.lastName)"
    }
    
    var userType: String {
        if userID != data.receiverID {
            return "Driver"
        }
        return "Passenger"
    }
    
    var image: String {
        if userID != data.receiverID {
            return data.receiverImage ?? ""
        }
        return data.senderImage ?? ""
    }
    
    var data: Chat
    
    var body: some View {
        VStack {
            if let data {
                
                HStack {
                    
                    Button {
                        if chatViewModel.openChatView {
                            chatViewModel.openChatView = false
                        }
                        if chatViewModel.openChatViewFromDetails {
                            chatViewModel.openChatViewFromDetails = false
                        }
                        if chatViewModel.openChatViewFromPublished {
                            chatViewModel.openChatViewFromPublished = false
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    
                    ChatViewTopBar(name: name, userType: userType, image: image)
                }
                .padding()
                
                VStack (alignment: .leading, spacing: 4) {
                    HStack {
                        Text(data.publish?.source ?? "")
                        Image(systemName: Constants.Icon.arrowLeft)
                        Text(data.publish?.destination ?? "")
                        
                        Spacer()
                    }
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.system(size: 13))
                    
                    Text("\(Formatters.getLongDate(date: data.publish?.date ?? Constants.Placeholders.defaultTime)) at \(Formatters.getFormattedDate(date: data.publish?.time ?? ""))")
                    .fontWeight(.light)
                    .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.gray.opacity(0.05))
                .padding(.horizontal)
                
                Divider()
                
                ScrollViewReader { value in
                    ScrollView (showsIndicators: true) {
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
                            Text(Formatters.checkDate(date: message.updatedAt))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            ChatBubble(isReceived: checkReceiver(message), message: message.content, time: Formatters.getFormattedDate(date: message.updatedAt))
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
            
            if let data = data  {
                MessageInput(data: data, id: userID)
                    .padding(.bottom, 8)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(data: Chat(id: 1, receiverID: 1, senderID: 2, publishID: 4, publish: Publish(id: 1, source: "", destination: "", passengersCount: 2, addCity: nil, date: nil, time: nil, setPrice: 3, aboutRide: "", userID: 2, createdAt: "", updatedAt: "", sourceLatitude: 3, sourceLongitude: 2, destinationLatitude: 3, destinationLongitude: 3, vehicleID: nil, bookInstantly: nil, midSeat: nil, selectRoute: nil, status: "", estimateTime: nil, addCityLongitude: nil, addCityLatitude: nil, distance: nil, bearing: nil), receiver: Receiver(id: 2, email: "", createdAt: "", updatedAt: "", jti: "", firstName: "", lastName: "", dob: "", title: "", phoneNumber: nil, bio: "", travelPreferences: nil, postalAddress: nil, activationDigest: "", activated: false, activatedAt: nil, activateToken: "", sessionKey: nil, averageRating: nil, otp: 2, phoneVerified: nil), sender: Receiver(id: 2, email: "", createdAt: "", updatedAt: "", jti: "", firstName: "", lastName: "", dob: "", title: "", phoneNumber: nil, bio: "", travelPreferences: nil, postalAddress: nil, activationDigest: "", activated: false, activatedAt: nil, activateToken: "", sessionKey: nil, averageRating: nil, otp: 2, phoneVerified: nil), receiverImage: "", senderImage: ""))
            .environmentObject(BaseViewModel())
            .environmentObject(ChatViewModel())
    }
}
