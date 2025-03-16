//
//  Components.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct SubscriberButton: View {
    var isSubscribed: Bool = true
    
    var body: some View {
        if isSubscribed {
            Image(systemName: "crown.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 30)
                .frame(width: 50)
                .padding()
                .background(.green.opacity(0.8), in: Circle())
        } else {
            HStack (spacing: 10){
                Image(systemName: "crown.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(.white)
                Text("Subscribe")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .frame(width: 130, height: 35)
            .background(.green.opacity(0.8), in: Capsule())
        }
    }
}

#Preview {
    SubscriberButton()
}
