//
//  MembersView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct FamilyView: View {
    @Binding var adults: Int
    @Binding var children: Int
    var totalMembers: Int {
        return adults + children
    }
    @Binding var addingMembers: Bool
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 20) {
                Text("Add family details")
                    .font(.title3)
                    .fontWeight(.bold)
                Divider()
                VStack {
                    Stepper("Number of Adults : \(adults)", value: $adults, in: 0...10)
                    Stepper("Number of Children : \(children)", value: $children, in: 0...10)
                }
                .fontWeight(.semibold)
                
                Text("Total number of members: \(totalMembers)")
                    .fontWeight(.bold)
                    .foregroundStyle(.green.opacity(0.8))
                Button {
                    addingMembers.toggle()
                } label: {
                    Text("Done")
                        .fontWeight(.bold)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.gray)
                        }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(20)
            .frame(width: 350, height: 300)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    FamilyView(adults: .constant(3), children: .constant(1), addingMembers: .constant(false))
}
