//
//  AppCard.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI


struct AppCard: View {
    var iconTitle: String
    var iconSub: String?
    var subTitle: String
    var money: String
    var view: Bool = true
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if view {
                Text("View")
                    .font(.system(size: 12))
                    .foregroundStyle(.blue)
                    .padding([.top, .trailing], 10)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(iconTitle)
                    .font(.title)
                
                HStack {
                    if let iconSub = iconSub, !iconSub.isEmpty {
                        Text(iconSub)
                    }
                    Text(subTitle)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundStyle(Color("textColor"))
                }
                
                Text("IDR \(money)")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundStyle(Color("textColor"))
            }
            .padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
        }
        .frame(width: 165, height: 135, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 40, y: 4)

    }
}

#Preview {
    AppCard(iconTitle: "🤑", subTitle: "Income", money: "0")
}
