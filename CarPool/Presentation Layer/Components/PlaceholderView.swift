//
//  PlaceholderView.swift
//  CarPool
//
//  Created by Nitin on 5/12/23.
//

import SwiftUI

struct PlaceholderView: View {
    
    var image: String
    var title: String
    var caption: String
    
    var body: some View {
        VStack{
            Image(image)
                .resizable()
                .frame(width: 240, height: 194)
                .padding()
            
            Text(title)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .padding(.top, 14)
            
            Text(caption)
                .font(.system(size: 14, design: .rounded))
                .padding(.top, 2)
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 44)
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView(image: "empty-inbox-view", title: "Your inbox is empty.", caption: "No messages right now. Book or offer a ride to contact someone")
    }
}
