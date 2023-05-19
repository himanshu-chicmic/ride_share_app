//
//  YourRidesView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct YourRidesView: View {
    var body: some View {
        
        // if no data in inbox
        PlaceholderView(
            image   : Constants.EmptyRidesView.image,
            title   : Constants.EmptyRidesView.title,
            caption : Constants.EmptyRidesView.caption
        )
    }
}

struct YourRidesView_Previews: PreviewProvider {
    static var previews: some View {
        YourRidesView()
    }
}
