//
//  RidesListItem.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct RidesListItem: View {
    
    // MARK: properties
    
    // MARK: body
    
    var body: some View {
        HStack (alignment: .top){
            VStack (alignment: .leading, spacing: 40){
                
                
                RidesListItemCity(
                    icon        : Constants.Icon.startLocation,
                    color       : .green,
                    location    : "Chandigarh",
                    time        : "5:00 pm"
                )
                
                RidesListItemCity(
                    icon        : Constants.Icon.endLocation,
                    color       : .red,
                    location    : "Patiala",
                    time        : "6:00 pm"
                )
                
            }
            .padding([.top, .horizontal])
            .layoutPriority(1)
            
            VStack(){
                Text("Rs. 100")
                    .font(.system(size: 16))
                
                Divider()
                
                Text(String(format: Constants.RidesData.info, ["Fri, 23 July", "2"]))
                    .font(.system(size: 10))
                    .fontWeight(.light)
                
                VStack (spacing: 2){
                    Image(Constants.Images.introImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                        .clipShape(Circle())
                    
                    Text("Driver Last")
                        .font(.system(size: 12))
                    
                    HStack (alignment: .firstTextBaseline, spacing: 2){
                        Text("4.8")
                        Image(systemName: Constants.Icon.star)
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.yellow)
                    }
                    .font(.system(size: 12))
                    .fontWeight(.light)
                }
            }
            .padding()
            .background(.gray.opacity(0.05))
            
        }
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 12)
    }
}

struct RidesListItem_Previews: PreviewProvider {
    static var previews: some View {
        RidesListItem()
    }
}
