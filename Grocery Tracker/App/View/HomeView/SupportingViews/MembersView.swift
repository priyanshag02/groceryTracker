//
//  MembersView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct MembersView: View {
    @Binding var adults: Int
    @Binding var children: Int
    var totalMembers: Int {
        return adults + children
    }
    @Binding var addingMembers: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20){
            Button {
                
            } label: {
                VStack (alignment: .leading) {
                    HStack (spacing: 15) {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .frame(width: 40, height: 40)
                            .background(.green.opacity(0.8), in: Circle())
                        Text("Total family members")
                            .fontWeight(.semibold)
                        Text("\(totalMembers)")
                            .fontWeight(.semibold)
                            .frame(width: 40, height: 40)
                            .background(.gray.opacity(0.25), in: Circle())
                        
                    }
                    HStack {
                        VStack (spacing: 10) {
                            Text("Adults")
                                .fontWeight(.bold)
                                .foregroundStyle(.green.opacity(0.8))
                            Text("\(adults)")
                                .fontWeight(.bold)
                        }
                        .frame(width: 100, height: 50)
                        Rectangle()
                            .frame(width: 1, height: 30)
                            .foregroundStyle(.gray)
                        VStack (spacing: 10) {
                            Text("Children")
                                .fontWeight(.bold)
                                .foregroundStyle(.green.opacity(0.8))
                            Text("\(children)")
                                .fontWeight(.bold)
                        }
                        .frame(width: 100, height: 50)
                    }
                    .frame(width: 340, height: 80)
                    .background(.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 20))
                    
                    Button {
                        withAnimation {
                            addingMembers.toggle()
                        }
                    } label: {
                        Text("View")
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                            .overlay {
                                Capsule()
                                    .stroke(lineWidth: 1)
                                    .frame(width: 330, height: 40)
                            }
                    }
                    .frame(width: 330, height: 40)
                    .padding(.top, 10)
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(width: 360, height: 200)
                .padding(10)
                .background(Color(.systemGray6).opacity(0.6), in: RoundedRectangle(cornerRadius: 20))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MembersView(adults: .constant(3), children: .constant(1), addingMembers: .constant(false))
}
