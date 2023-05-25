//
//  PickerView.swift
//  CarPool
//
//  Created by Himanshu on 5/23/23.
//

import SwiftUI

/// common view for list picker
struct PickerView: View {
    
    // MARK: - properties
    
    // binding var for string
    @Binding var value: String
    // selectable values array
    var selectableValues: [String]
    // placholder/default text
    var placeholder: String
    
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    // MARK: - body
    
    var body: some View {
        Picker("", selection: $value) {
            ForEach(
                selectableValues,
                id: \.self
            ) {
                Text($0)
            }
        }
        .pickerStyle(.inline)
        .onChange(of: value) { val in
            if val.isEmpty {
                value = placeholder
            }
            
            detailsViewModel.showPicker = false
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(
            value: .constant(""),
            selectableValues: [],
            placeholder: ""
        )
    }
}
