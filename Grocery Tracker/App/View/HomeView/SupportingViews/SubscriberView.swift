//
//  SubscriberView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 8/03/25.
//

import SwiftUI

struct SubscriberView: View {
    @Binding var subscriberMode: Int
    var modeTitle: [String] = ["Monthly", "Annual"]
    var modeAmount: [Double] = [1.19, 11.99]
    var subscriberDes: [String] = ["Automatically track pantry stock with expiration date reminders and alerts", "Scan barcodes to quickly add items to your inventory", "Get access to widgets for better accessibility", "Link items in the inventory to recipes and suggest recipes based on your inventory", "Price comparison across different stores", "Weekly or monthly reports on grocery spending habits"]
    var imageString: [String] = ["bell.badge.fill", "camera.metering.none", "rectangle.grid.1x2.fill", "shippingbox.fill", "eurosign", "book.pages"]
    @State var currentIndex: Int = 0
    @State var timer: Timer?
    @Binding var isSubscribed: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 150) {
                VStack (spacing: 60) {
                    VStack (spacing: 20) {
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray6).opacity(0.001))
                                .frame(width: UIScreen.main.bounds.width*0.3, height: 60)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 2)
                                        .foregroundStyle(.green.opacity(0.8))
                                        .offset(x: subscriberMode == 0 ? 0 : UIScreen.main.bounds.width*0.3 + 5)
                                }
                            
                            HStack  {
                                ForEach (0...1, id: \.self) {index in
                                    Button {
                                        withAnimation {
                                            subscriberMode = index
                                        }
                                    } label: {
                                        VStack {
                                            Text(modeTitle[index])
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .frame(width: UIScreen.main.bounds.width*0.3, height: 60)
                                                .foregroundStyle(subscriberMode == index ? .green.opacity(0.8) : .white)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .frame(width: (UIScreen.main.bounds.width * 0.6))
                        
                        if subscriberMode == 0 {
                            HStack (spacing: 0) {
                                Text(modeAmount[0], format: .currency(code: "eur"))
                                Text("/m")
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.green.opacity(0.8))
                            .frame(width: (UIScreen.main.bounds.width * 0.6), height: 50)
                        } else {
                            HStack (spacing: 0) {
                                Text(modeAmount[1], format: .currency(code: "eur"))
                                Text("/y")
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.green.opacity(0.8))
                            .frame(width: (UIScreen.main.bounds.width * 0.6), height: 50)
                        }
                    }
                    .frame(width: 300, height: 150)
                    .padding(.vertical)
                    .background(Color(.systemGray6).opacity(0.5), in: RoundedRectangle(cornerRadius: 20))
                    
                    VStack (spacing: 20) {
                        Text("What you get?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green.opacity(0.8))
                        
                        LazyVStack (spacing: 10) {
                            ScrollView {
                                ScrollViewReader { scrollViewProxy in
                                    ForEach (0..<subscriberDes.count, id: \.self) { index in
                                        HStack (spacing: 30) {
                                            Image(systemName: imageString[index])
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20)
                                                .padding()
                                                .background(.green.opacity(0.8), in: Circle())
                                            Text(subscriberDes[index])
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                                .frame(width: 200, height: 80, alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .font(.subheadline)
                                        }
                                    }
                                    .onAppear {
                                        startTimer(scrollViewProxy: scrollViewProxy)
                                    }
                                }
                            }
                            .scrollIndicators(.never)
                            .frame(width: 300, height: 100)
                        }
                    }
                }
                VStack (spacing: 20) {
                    if subscriberMode == 1 {
                        Text("Save 16% with annual billing")
                            .font(.caption)
                            .foregroundStyle(.green.opacity(0.8))
                    }
                    Button {
                        isSubscribed.toggle()
                        dismiss()
                    } label: {
                        VStack (spacing: 5) {
                            Text("Subscribe Now")
                                .font(.headline)
                                .fontWeight(.semibold)
                            HStack (spacing: 0){
                                Text((modeAmount[subscriberMode]), format: .currency(code: "eur"))
                                Text(subscriberMode == 0 ? "/m" : "/y")
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                        }
                        .padding(10)
                        .frame(width: 180)
                        .background(.green.opacity(0.8), in: Capsule())
                    }
                    .padding(.bottom, 80)
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(height: 120, alignment: .bottom)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label:  {
                        HStack {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .opacity(0.5)
                            Text("I'll rather have spoilt food")
                                .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(height: 500)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func startTimer(scrollViewProxy: ScrollViewProxy) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            currentIndex = (currentIndex + 1) % subscriberDes.count
            withAnimation {
                scrollViewProxy.scrollTo(currentIndex, anchor: .center)
            }
        }
    }
}

#Preview {
    SubscriberView(subscriberMode: .constant(1), isSubscribed: .constant(false))
}
