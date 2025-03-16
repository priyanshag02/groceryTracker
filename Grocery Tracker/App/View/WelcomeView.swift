//
//  WelcomeView.swift
//  Grocery Tracker
//
//  Created by Priyansh on 9/03/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var cI: Int = 0
    @State private var welcomeTimer: Timer?
    private let welcomeArray: [String] = [
        "Track pantry stock with expiration date reminders and alerts",
        "Compare prices across different stores and save money",
        "Get weekly or monthly reports on grocery spending habits"
    ]
    private let imageString: [String] = ["bag", "text.page.badge.magnifyingglass", "chart.line.uptrend.xyaxis"]
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 100) {
                TabView(selection: $cI) {
                    ForEach(0..<welcomeArray.count, id: \.self) { index in
                        VStack (alignment: .center, spacing: 45) {
                            Image(systemName: imageString[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 125)
                                .padding(.leading , index == 1 ? 30 : 0)
                            Text(welcomeArray[index])
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(width: 250)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 500)
                .onAppear {
                    startTimer()
                }
                
                VStack (spacing: 20) {
                NavigationLink (destination: AuthView(selectedTab: 1)) {
                    Text("Get started")
                        .fontWeight(.bold)
                        .foregroundStyle(.green)
                        .padding()
                        .background(.white, in: Capsule())
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink (destination: AuthView(selectedTab : 0)) {
                    Text("Already have an account")
                        .font(.footnote)
                        .foregroundStyle(.white)
                }
            }
            .padding()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.green.opacity(0.7))
    }
        .ignoresSafeArea()
}

private func startTimer() {
    welcomeTimer?.invalidate()
    welcomeTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
        withAnimation {
            cI = (cI + 1) % welcomeArray.count
        }
    }
}
}

#Preview {
    WelcomeView()
}
