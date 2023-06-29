//
//  DefaultPickeres.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

/// default picker for application
/// contains date and gender picker
/// the picker are styled as wheel type
struct DefaultPickers: View {
    
    // MARK: - properties
    
    var pickerType: PickerFieldIdentifier
    
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    var dateRange: ClosedRange<Date> = Formatters.defaultDateMin...Formatters.defaultDate
    
    @Binding var date: Date
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .trailing) {
            
            Button {
                detailsViewModel.showPicker.toggle()
            } label: {
                Image(systemName: pickerType == .date ? Constants.Icon.check : Constants.Icon.close)
            }
            .padding([.trailing, .top])
            .padding(.bottom, 8)

            GetPickers(pickerType: pickerType, dateRange: dateRange, date: $date)
                .labelsHidden()
        }
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.1))
    }
}

struct DefaultPickeres_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPickers(pickerType: .modelYear, date: .constant(.now))
    }
}
