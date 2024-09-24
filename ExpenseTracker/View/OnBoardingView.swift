//
//  OnBoardingView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 18/09/24.
//

import SwiftUI
import Lottie

struct OnBoardingView: View {
    
    private var onBoarding = [
    OnBoardingModel(filename: "list.json", title: "Track Your Spending", description: "Record your expenses easily and neatly. Monthy helps you track your spending to keep your finances in control and more transparent!"),
    OnBoardingModel(filename: "503020.json", title: "Manage your Finances", description: "With 50% for needs, 30% for goals, and 20% for savings. Monthy helps you achieve your financial goals!")
    ]
    
    @State private var currentStep = 0
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            VStack{
                HStack{
                    Spacer()
                    Button{
                        withAnimation {
                            self.currentStep = onBoarding.count - 1
                        }
                    } label: {
                        Text(currentStep < onBoarding.count - 1 ? "Skip" : "")
                            .padding(16)
                            .foregroundColor(.gray)
                    }
                }
                
                TabView(selection: $currentStep){
                    ForEach(0..<onBoarding.count) { board in
                        VStack{
                            Spacer()
                            LottieView(animation: .named(onBoarding[board].filename))
                                .configure({
                                    lottieAnimation in lottieAnimation.contentMode = .scaleAspectFill
                                })
                                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                                .frame(width: 270, height: 270)
                                .padding(.bottom, 15)
                            Text(onBoarding[board].title)
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .foregroundStyle(Color("textColor"))
                                .padding(.bottom,15)
                            Text(onBoarding[board].description)
                                .padding(.horizontal,20)
                                .font(.system(size: 16, weight: .regular, design: .default))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color("textColor"))
                            Spacer()
                        }
                        .tag(board)
                        .padding()
                        .transition(.slide)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack{
                    ForEach(0..<onBoarding.count){ board in
                        if board == currentStep {
                            Rectangle()
                                .frame(width: 20,height: 10)
                                .cornerRadius(10)
                                .foregroundColor(Color("appColor"))
                        } else{
                            Circle()
                                .frame(width: 10,height: 10)
                                .foregroundColor(Color("appColor").opacity(0.4))
                        }
                    }
                }
                .padding(.bottom, 30)
                
                Button{
                    withAnimation {
                        if self.currentStep < onBoarding.count - 1{
                            self.currentStep += 1
                        } else {
                            isOnboarding = false
                        }
                    }
                } label: {
                    AppButton(title: currentStep < onBoarding.count - 1 ? "Next" : "Get started", textColor: .white, backgroundColor: "appColor")  .padding(.bottom,50)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}

#Preview {
    OnBoardingView()
}
