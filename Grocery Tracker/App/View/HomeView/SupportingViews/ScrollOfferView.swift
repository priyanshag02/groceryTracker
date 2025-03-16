//
//  ScrollOfferView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct ScrollOfferView: View {
    var offerArrayTitle: [String] = ["Just For you!", "Offer of the day", "Salad needs"]
    var offerArrayDescription: [String] = ["Claim your exclusive order", "Get 20% off on your cart", "Get yourself a healthy diet"]
    @State var cI: Int = 0
    @State var timer: Timer?
    
    var body: some View {
        ScrollView (.horizontal) {
            ScrollViewReader { scrollViewProxy in
                LazyHStack {
                    ForEach(0..<offerArrayTitle.count, id: \.self) {index in
                        Button {
                            
                        } label: {
                            HStack (alignment: .center, spacing: 10) {
                                Image(systemName: "flame.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundStyle(.yellow)
                                    .padding(.leading, 10)
                                VStack (alignment: .leading, spacing: 10){
                                    Text(offerArrayTitle[index])
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(offerArrayDescription[index])
                                        .font(.footnote)
                                        .opacity(0.9)
                                }
                                .frame(width: 180, height: 200)
                            }
                            .frame(width: 270, height: 100)
                            .background(.green.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .scrollTransition {content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.5)
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                    }
                }
                .onAppear {
                    startTimer(scrollViewProxy: scrollViewProxy)
                }
            }
        }
        .scrollIndicators(.never)
        .scrollTargetLayout()
        .contentMargins(.horizontal, (UIScreen.main.bounds.width - 270)/2)
        .scrollTargetBehavior(.viewAligned)
    }
    
    private func startTimer(scrollViewProxy: ScrollViewProxy) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            cI = (cI + 1) % offerArrayTitle.count
            withAnimation {
                scrollViewProxy.scrollTo(cI, anchor: .center)
            }
        }
    }
}

#Preview {
    ScrollOfferView()
}
