//
//  SplashScreenView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI

struct SplashScreenView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @State var isActive: Bool = false
    @State private var fadeIn = false
    var body: some View {
        ZStack{
            Color("appColor")
                .ignoresSafeArea()
            if self.isActive{
                if isOnboarding {
                    OnBoardingView()
                } else {
                    HomeView()
                }
            }else{
                Text("Monthy")
                    .foregroundStyle(.white)
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeIn(duration: 1), value: fadeIn)
                    .font(.system(size: 40, weight: .bold, design: .default))
            }
        }.onAppear {
            
            withAnimation {
                self.fadeIn = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
