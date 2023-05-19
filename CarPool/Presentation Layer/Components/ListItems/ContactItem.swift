//
//  ContactItem.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

/// contact list item for inbox
/// message view
struct ContactItem: View {
    
    // MARK: - properties
    
    // contact item properties
    var image: String
    var name: String
    var message: String
    var time: String
    
    // MARK: - body
    
    var body: some View {
        
        HStack (spacing: 12){
            
            // person profile
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(
                    width   : 44,
                    height  : 44
                )
                .clipShape(Circle())
            
            // horizontal stack for name, message and time
            HStack(alignment: .top) {
                VStack (alignment: .leading){
                    
                    // person name
                    Text(name)
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                    
                    // last message received
                    Text(message)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                }
                
                Spacer()
                
                // time of message received
                Text(time)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .fontWeight(.light)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .background(.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ContactItem_Previews: PreviewProvider {
    static var previews: some View {
        ContactItem(
            image   : Constants.Images.introImage,
            name    : "Himanshu",
            message : "message message message...",
            time    : "12:38"
        )
    }
}
