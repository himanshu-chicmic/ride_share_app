//
//  RideDetailVehicleInformation.swift
//  CarPool
//
//  Created by Nitin on 6/12/23.
//

import SwiftUI

struct RideDetailVehicleInformation: View {
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            
            Rectangle()
                .frame(height: 4)
                .foregroundColor(.gray.opacity(0.05))
                .background(.gray.opacity(0.05))
                .padding(.bottom)
            
            Group {
                Text(Constants.RideDetails.vehicleDetails)
                    .padding(.bottom, 2)
                
                if let data = baseViewModel.singleVehicleData?.status.data?.first {
                    ForEach(data.getDetailsArray(data: data), id: \.self) { value in
                        if !value.isEmpty {
                            Text(value)
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .padding(.vertical, 2)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RideDetailVehicleInformation_Previews: PreviewProvider {
    static var previews: some View {
        RideDetailVehicleInformation()
            .environmentObject(BaseViewModel())
    }
}
