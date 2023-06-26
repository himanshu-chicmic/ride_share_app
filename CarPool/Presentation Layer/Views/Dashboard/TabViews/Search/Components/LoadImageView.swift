//
//  LoadImageView.swift
//  CarPool
//
//  Created by Nitin on 6/12/23.
//

import SwiftUI

struct LoadImageView: View {
    
    var driverImage: String
    
    var body: some View {
        // profile can be changed
        // by clicking on it
        AsyncImage(url: URL(string: driverImage)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            if driverImage.isEmpty {
                Image(Constants.Images.carpool)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView()
                }
            }
        }
        .frame(width: 42, height: 42)
        .clipShape(Circle())
    }
}

struct LoadImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadImageView(driverImage: "")
    }
}
