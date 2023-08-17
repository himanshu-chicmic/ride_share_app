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
    
    var image: String
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
        HStack (alignment: .center) {
            // person profile
            LoadImageView(driverImage: image, isLoading: true)
            
            VStack (alignment: .leading) {
                Text(name)
                    .font(.system(size: 15))
                Text(userType)
                    .font(.system(size: 13))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ChatViewTopBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatViewTopBar(name: "Arjun Singh", userType: "Driver", image: "")
    }
}
