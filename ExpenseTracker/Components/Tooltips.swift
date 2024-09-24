//
//  Tooltips.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 24/09/24.
//
import TipKit

struct Tooltips: Tip {
    var title: Text {
        Text(LocalizedStringKey("First Income!"))
    }

    var message: Text? {
        Text(LocalizedStringKey("This is your income section. Tap here to add your first income!"))
    }
}
