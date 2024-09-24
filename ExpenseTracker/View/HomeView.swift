//
//  HomeView.swift
//  ExpenseTracker
//
//  Created by MacBook Air on 16/09/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = SavingViewModel()
    @StateObject var viewModelTransaction = TransactionViewModel()
    
    @Query var transaction: [TransactionModel]
    @Query(filter: #Predicate<TransactionModel> { $0.status == "income" }) var incomeTransactions: [TransactionModel]
    
    @Query var balance: [BalanceModel]
    @Query var savings: [SavingsModel]
    @State var transactionType: String = "Income"
    @State private var showingAddTransaction = false
    @State private var selectedSegment = 0
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            Spacer()
            if incomeTransactions.isEmpty {
                Button{
                    showingAddTransaction.toggle()
                    transactionType = "Income"
                }label: {
                    AppButton(title: "+ Add First Income", textColor: .white, backgroundColor: "appColor")
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.horizontal)
            }else{
                VStack(alignment: .leading, spacing: 8) {
                    Text("Balance 50%")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                    if let balanceAmount = balance.first?.amount {
                        Text("IDR \(numberFormatter.string(from: NSNumber(value: balanceAmount)) ?? "0")")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                    } else {
                        Text("Rp 0")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                .background(Color("appColor"))
            }
            VStack(spacing: 12){
                Text("Summary")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .leading)
                    .font(.headline)
                    .padding(.bottom, 8)
                HStack{
                    AppCard(iconTitle: "🤑", iconSub: "+", subTitle: "Income", money: "0",view: false)
                    let totalExpense = viewModelTransaction.calculateTotalExpense(transactions: transaction)
                    NavigationLink(destination: ExpenseView()){
                        AppCard(iconTitle: "💸", iconSub: "-", subTitle: "Expense", money: "\(numberFormatter.string(from: NSNumber(value: totalExpense)) ?? "0")")
                    }
                }
                HStack{
                    AppCard(iconTitle: "👝", subTitle: "Saving 20%", money:  "\(numberFormatter.string(from: NSNumber(value: balance.first?.savings ?? 0)) ?? "0")")
                    NavigationLink(destination: GoalsView()){
                        AppCard(iconTitle: "📌", subTitle: "Goals 30%", money: "\(numberFormatter.string(from: NSNumber(value: balance.first?.goals ?? 0)) ?? "0")")
                    }
                }.padding(.bottom, 15)
                
                HStack{
                    Text("Recent Transaction")
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .font(.headline)
                    Button(action: {
                        showingAddTransaction.toggle()
                        transactionType = "Expenses"
                    }) {
                        Text("Add Transaction")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                            .fontWeight(.regular)
                    }
                }
                
                VStack {
                    Picker("Select Option", selection: $selectedSegment) {
                        Text("Expenses").tag(0)
                        Text("Income").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    if selectedSegment == 0 {
                        let filteredExpenses = transaction
                            .filter { $0.status == "expense" }
                            .sorted(by: { $0.date > $1.date })
                        if filteredExpenses.isEmpty {
                            Text("No recent transactions now.")
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                        } else {
                            List(filteredExpenses) { transaction in
                                CardTransaction(transaction: transaction)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                                    .padding(.bottom, 10)
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                        }
                        
                    } else if selectedSegment == 1 {
                        let filteredIncome = transaction
                            .filter { $0.status == "income" }
                            .sorted(by: { $0.date > $1.date })
                        if filteredIncome.isEmpty {
                            Text("No recent transactions now.")
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                        } else {
                            List(filteredIncome) { transaction in
                                CardTransaction(transaction: transaction)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                                    .padding(.bottom, 10)
                            }
                            .listStyle(PlainListStyle())
                            .background(Color.clear)
                        }
                    }
                }
            }.padding()
                .sheet(isPresented: $showingAddTransaction) {
                    AddTransactionView(isPresented: $showingAddTransaction,
                                       transactionType: $transactionType)
                }
        }
        .onAppear {
            viewModel.calculateMonthlySavings(savings: savings)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    HomeView()
}

