//
//  ShowPickerText.swift
//  CarPool
//
//  Created by Nitin on 5/22/23.
//

import SwiftUI

struct ShowPickerText: View {
    
    @Binding var text: String
    
    var placeholder: String
    
    @Binding var showPicker: Bool
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(
                    text == placeholder
                    ? .gray.opacity(0.7)
                    : .black
                )
            Spacer()
        }
        .onTapGesture {
            withAnimation {
                showPicker.toggle()
            }
        }
        .onAppear {
            showPicker = false
        }
    }
}

struct ShowPickerText_Previews: PreviewProvider {
    static var previews: some View {
        ShowPickerText(
            text        : .constant(""), placeholder: "",
            showPicker  : .constant(false)
        )
    }
}
