//
//  InboxView.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

struct InboxView: View {
    var body: some View {
        
        // if no data in inbox
        PlaceholderView(
            image   : Constants.EmptyInboxView.image,
            title   : Constants.EmptyInboxView.title,
            caption : Constants.EmptyInboxView.caption
        )
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
