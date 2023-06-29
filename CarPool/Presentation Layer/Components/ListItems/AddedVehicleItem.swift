//
//  AddedVehicleItem.swift
//  CarPool
//
//  Created by Himanshu on 6/2/23.
//

import SwiftUI

struct AddedVehicleItem: View {
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    var data: VehiclesDataClass?
    
    @State var showDeleteConfirmation: Bool = false
    
    var body: some View {
        if let data = data {
            HStack {
                VStack (alignment: .leading) {
                    Text("\(data.vehicleName) | \(data.vehicleBrand)")
                        .font(.system(size: 16))
                    Text("\(data.vehicleType) | \(data.vehicleColor) | \(Formatters.yearString(at: data.vehicleModelYear))")
                        .font(.system(size: 14, weight: .light))
                }
                
                Spacer()
                
                NavigationLink(destination: {
                    EditDetailsView(title: "Edit Vehicle", isProfile: false, vehiclesData: data)
                }, label: {
                    Image(systemName: Constants.Icon.edit)
                })
                .padding(.trailing)
                
                Button {
                    showDeleteConfirmation.toggle()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }

            }.padding(.top)
            // confirmation dialog
            // prompting user with options
            // to get image from galler
            // to click a picture
                .confirmationDialog("Are you sure to remove this vehicle?", isPresented : $showDeleteConfirmation, titleVisibility: .visible) {
                    Button("Remove", role: .destructive) {
                        baseViewModel.sendVehiclesRequestToApi(httpMethod: .DELETE, requestType: .deleteVehicle, data: ["id": data.id])
                }
            }
        }
    }
}

struct AddedVehicleItem_Previews: PreviewProvider {
    static var previews: some View {
        AddedVehicleItem()
    }
}
