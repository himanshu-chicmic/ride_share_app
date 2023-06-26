//
//  LocationTextView.swift
//  CarPool
//
//  Created by Nitin on 6/12/23.
//

import Foundation
import SwiftUI

struct LocationTextView: View {
    
    var title: String
    var location: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .fontWeight(.light)
            Text(location)
                .font(.system(size: 14))
                .lineLimit(1)
        }
    }
}
