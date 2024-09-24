//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SplashScreenView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TransactionModel.self)
}
