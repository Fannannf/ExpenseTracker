//
//  ExpenseView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI
import Charts
import SwiftData

struct ExpenseView: View {
    @Query var transaction: [TransactionModel]
    @State private var selectedCount: Int?
    @State private var selectedSector: String?
    @State private var focusedSector: String? = nil
    @State private var focusedCategory: String? = nil
    @State private var selectedMonth: String = ""
    @State private var filteredExpenses: [TransactionModel] = []

    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: Date())
    }
    
    private func findSelectedSector(value: Int) -> String? {
        var accumulatedCount = 0

        let category = categoryExpense.first { category in
            accumulatedCount += category.count
            return value <= accumulatedCount
        }

        return category?.name
    }
    
    var body: some View {
        VStack{
            VStack {
                Chart {
                    ForEach(categoryExpense, id: \.name) { category in
                        SectorMark(
                            angle: .value("Category", category.count),
                            innerRadius: .ratio(0.65),
                            angularInset: 2
                        )
                        .opacity(focusedCategory == nil ? 1.0 : (focusedCategory == category.name ? 1.0 : 0.5))
                        .foregroundStyle(category.color)
                        .cornerRadius(5)
                        .annotation(position: .overlay) {
                            Text("\(category.count)")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.white)
                            
                        }
                    }
                }
                .chartBackground { chartProxy in
                    GeometryReader { geometry in
                        if let anchor = chartProxy.plotFrame {
                            let frame = geometry[anchor]
                            Text("Categories")
                                .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }
                .onChange(of: selectedCount) { oldValue, newValue in
                    if let newValue {
                        let selected = findSelectedSector(value: newValue)
                        focusedCategory = selected
                    } else {
                        focusedCategory = nil
                    }
                }
                .padding(.vertical, 10)
                .frame(height: 250)
                .chartAngleSelection(value: $selectedCount)
                
                HStack {
                    ForEach(categoryExpense, id: \.name) { category in
                        HStack {
                            Circle()
                                .fill(category.color)
                                .frame(width: 10, height: 10)
                            Text(category.name)
                                .font(.system(size: 10))
                        }
                        .onTapGesture {
                            if focusedCategory == category.name {
                                focusedCategory = nil
                            } else {
                                focusedCategory = category.name
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.top, 16)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 3, y: 1)
            
            HStack {
                Text("Recent Transaction")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .padding(.top, 20)

                HStack {
                    Picker("This Month", selection: $selectedMonth) {
                        ForEach(months, id: \.self) { month in
                            Text(month).tag(month)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.top, 20)
                }
            }
            
            let filteredExpense = filteredExpenses
                            .filter { $0.status == "expense" }
                            .sorted { $0.date > $1.date }
            
            if filteredExpense.isEmpty {
                Text("No recent transactions now.")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                List(filteredExpense) { transaction in
                    CardTransaction(transaction: transaction)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.bottom, 10)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
            }
            Spacer()
        }
        .padding()
        .padding(.top, 20)
        .navigationTitle("Expense")
        .onAppear {
            selectedMonth = getCurrentMonth()
            updateFilteredExpenses()
        }
        .onChange(of: selectedMonth) { newValue in
            updateFilteredExpenses()
        }
    }
    
    private func updateFilteredExpenses() {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        guard let monthIndex = months.firstIndex(of: selectedMonth) else { return }
        
        filteredExpenses = transaction.filter { transaction in
            let transactionMonth = calendar.component(.month, from: transaction.date)
            let transactionYear = calendar.component(.year, from: transaction.date)
            
            return transaction.status == "expense" && transactionMonth == monthIndex + 1 && transactionYear == currentYear
        }.sorted { $0.date > $1.date }
    }
    
    private var categoryExpense: [(name: String, count: Int, color: Color)] {
        let categoryColors: [String: Color] = [
            "Living": Color("chartColor1"),
            "Education": Color("chartColor2"),
            "Fashion": Color("chartColor3"),
            "Food & Beverage": Color("chartColor4"),
            "Other": Color("chartColor5")
        ]
        
        var counts: [String: Int] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        guard let monthIndex = months.firstIndex(of: selectedMonth) else { return [] }
        
        for trans in transaction {
            if trans.status == "expense" {
                let transactionMonth = Calendar.current.component(.month, from: trans.date)
                let transactionYear = Calendar.current.component(.year, from: trans.date)
                if transactionMonth == monthIndex + 1 && transactionYear == Calendar.current.component(.year, from: Date()) {
                    counts[trans.categori, default: 0] += trans.amount
                }
            }
        }
        
        return counts.map { (name: $0.key, count: $0.value, color: categoryColors[$0.key] ?? Color.gray) }
                     .sorted { $0.name < $1.name }
    }
    
}

#Preview {
    ExpenseView()
}
