//
//  LoadImageView.swift
//  CarPool
//
//  Created by Nitin on 6/12/23.
//

import SwiftUI

struct LoadImageView: View {
    
    // image
    var driverImage: String
    var defaultSize: CGFloat = 44
    
    // bool to check image loading
    @State var isLoading: Bool = true
    
    var body: some View {
        AsyncImage(url: URL(string: driverImage)) { image in
            image
                .resizable()
                .scaledToFill()
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
        .frame(width: defaultSize, height: defaultSize)
        .clipShape(Circle()).onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+5) {
                isLoading = false
            }
        }
    }
}

struct LoadImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadImageView(driverImage: "")
    }
}
