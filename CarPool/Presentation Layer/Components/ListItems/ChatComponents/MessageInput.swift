//
//  TextArea.swift
//  CarPool
//
//  Created by Himanshu on 8/10/23.
//

import SwiftUI

struct MessageInput: View {
    
    @State var inputText: String = ""
    
    var body: some View {
        HStack {
            
            TextField("Type your message...", text: $inputText)
                .padding()
                .background(.gray.opacity(0.05))
                .cornerRadius(1000)
                .font(.system(size: 15))
            
            Button(action: {
                // do something
            }, label: {
                Image(systemName: "paperplane.fill")
                    .padding()
                    .background(.blue.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(1000)
            })
            
        }
        .padding(.horizontal)
    }
}

struct MessageInput_Previews: PreviewProvider {
    static var previews: some View {
        MessageInput()
    }
}
