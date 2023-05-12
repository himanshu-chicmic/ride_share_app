//
//  RidesListItem.swift
//  CarPool
//
//  Created by Nitin on 5/12/23.
//

import SwiftUI

struct RidesListItem: View {
    var body: some View {
        VStack (spacing: 44){
            
            HStack (alignment: .top, spacing: 54){
                
                VStack(spacing: 34){
                    HStack(alignment: .top, spacing: 34){
                       Text("05:10")
                        
                       Text("Sahibzada Ajit Singh Nagar")
                    }
                    HStack(alignment: .top, spacing: 34){
                       Text("09:10")
                        
                       Text("Sahibzada Ajit Singh Nagar")
                    }
                }
                
                Spacer()
                
                VStack{
                    Text("4h00m")
                    Text("590Rs.")
                }
            }
            
            HStack (spacing: 8){
                // person profile
                Image("intro-image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
                
                Text("Driver Lastname")
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .background(.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct RidesListItem_Previews: PreviewProvider {
    static var previews: some View {
        RidesListItem()
    }
}
