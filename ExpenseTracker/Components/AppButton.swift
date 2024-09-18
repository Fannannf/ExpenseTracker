//
//  AppButton.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI

struct AppButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: String
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .bold, design: .default))
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .foregroundColor(textColor)
            .background(
                Color(backgroundColor)
            )
            .cornerRadius(10)
    }
}

#Preview {
    AppButton(title: "+ Add", textColor: .white, backgroundColor: "appColor")
}
