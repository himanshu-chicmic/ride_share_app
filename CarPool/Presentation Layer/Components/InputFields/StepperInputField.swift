//
//  StepperInputField.swift
//  CarPool
//
//  Created by Nitin on 5/26/23.
//

import SwiftUI

struct StepperInputField: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @State var number: Int = 0
    
    var body: some View {
        HStack {
            Button {
                number -= 1
            } label: {
                Image(systemName: Constants.Icon.minusCircle)
                    .resizable()
                    .frame(width: 34, height: 34)
            }
            .disabled(number == 0)
            .padding()
            
            Spacer()
            
            Text("\(number)")
                .font(.system(size: 24))
            
            Spacer()
            
            Button {
                number += 1
            } label: {
                Image(systemName: Constants.Icon.plusCircle)
                    .resizable()
                    .frame(width: 34, height: 34)
            }
            .disabled(number == 8)
            .padding()
        }
        .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
        .onChange(of: number, perform: { num in
            searchViewModel.numberOfPersons = String(num)
        })
        .onAppear {
            number = Int(searchViewModel.numberOfPersons)!
        }
    }
}

struct StepperInputField_Previews: PreviewProvider {
    static var previews: some View {
        StepperInputField()
            .environmentObject(SearchViewModel())
    }
}
