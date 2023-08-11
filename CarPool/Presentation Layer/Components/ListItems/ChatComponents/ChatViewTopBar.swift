//
//  ChatViewTopBar.swift
//  CarPool
//
//  Created by Himanshu on 8/10/23.
//

import SwiftUI

struct ChatViewTopBar: View {
    
    var name: String
    var userType: String
    
    var dateAndTime: String
    
    var pickupLocation: String
    var dropLocation: String
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
        VStack {
            HStack (alignment: .center) {
                Button {
                    chatViewModel.openChatView.toggle()
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                // person profile
                Image(Constants.EmptyRidesView.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width  : 44, height : 44)
                    .clipShape(Circle())
                    .padding(.horizontal, 4)
                
                VStack (alignment: .leading) {
                    Text(name)
                        .font(.system(size: 15))
                    Text(userType)
                        .font(.system(size: 13))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            
            VStack (alignment: .leading, spacing: 4) {
                HStack {
                    Text(pickupLocation)
                    Image(systemName: Constants.Icon.arrowLeft)
                    Text(dropLocation)
                    
                    Spacer()
                }
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.system(size: 13))
                
                Text(dateAndTime)
                .fontWeight(.light)
                .font(.system(size: 12))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.gray.opacity(0.05))
            .padding(.horizontal)
            
            Divider()
        }
    }
}

struct ChatViewTopBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewTopBar(name: "Arjun Singh", userType: "Driver", dateAndTime: "15 May, 2023, 11:40 AM", pickupLocation: "Meerut", dropLocation: "Gurgaon")
    }
}
