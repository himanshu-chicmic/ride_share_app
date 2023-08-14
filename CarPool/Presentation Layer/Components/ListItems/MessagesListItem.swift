//
//  ContactItem.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

/// contact list item for inbox
/// message view
struct MessagesListItem: View {
    
    // MARK: - properties
    
    // contact item properties
    var image: String
    var name: String
    var pickupLocation: String
    var dropLocation: String
    
    @State var isLoading: Bool = false
    
    // MARK: - body
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            // person profile
            AsyncImage(url: URL(string: image)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .onAppear {
                        isLoading = false
                    }
            } placeholder: {
                if isLoading {
                    ZStack {
                        Color.gray.opacity(0.1)
                        ProgressView()
                    }
                } else {
                    Image(Constants.Images.carpool)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(Circle()).onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+7) {
                    isLoading = false
                }
            }
            
            // horizontal stack for name, message and time
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    
                    // person name
                    Text(name)
                        .font(.system(size: 15, design: .rounded))
                        .fontWeight(.regular)
                    
                    // last message received
                    HStack {
                        Text(pickupLocation)
                        Image(systemName: Constants.Icon.arrowLeft)
                        Text(dropLocation)
                        
                        Spacer()
                    }
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .background(.gray.opacity(0.025))
        .cornerRadius(12)
    }
}

struct ContactItem_Previews: PreviewProvider {
    static var previews: some View {
        MessagesListItem(
            image   : Constants.Images.carpool,
            name    : "Himanshu",
            pickupLocation: "Meerut",
            dropLocation: "Gurgaon"
        )
    }
}
