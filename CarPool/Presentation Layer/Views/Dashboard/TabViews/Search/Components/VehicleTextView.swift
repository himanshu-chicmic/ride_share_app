//
//  VehicleTextView.swift
//  CarPool
//
//  Created by Nitin on 6/29/23.
//

import SwiftUI

struct VehicleTextView: View {
    
    var data: VehiclesDataClass
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        HStack {
            Text("\(data.vehicleName) - \(data.vehicleBrand)")
            if data.id == searchViewModel.selectedVehicleId {
                Image(systemName: Constants.Icon.check)
                    .font(.system(size: 14))
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
        }
        .onTapGesture {
            searchViewModel.selectedVehicleId = data.id
            searchViewModel.selectedVehicle = "\(data.vehicleName) - \(data.vehicleBrand)"
            searchViewModel.activeSearchView.toggle()
        }
    }
}
