//
//  CircleProgressView.swift
//  CarPool
//
//  Created by Nitin on 5/22/23.
//

import SwiftUI

struct CircleProgressView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .background(.gray.opacity(0.25))
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView()
    }
}
