//
//  ContentView.swift
//  LikeCoinBalance
//
//  Created by Juan on 13/07/2021.
//

import SwiftUI

struct LikeCoinBalanceSettings: View {
    let defaults = UserDefaults(suiteName: Config.suitNameStr)!
    
    @State var cosmosWalletAddress: String
    @State var balance: String
    @State var isSaveVisible: Bool = false
    @State var showSaveAlert: Bool = false
    @State var isRefreshVisible: Bool = false

    init() {
        self._cosmosWalletAddress = State(initialValue: defaults.string(forKey: Constant.defaultWalletAddressStr) ?? "")
        self._balance = State(initialValue: defaults.string(forKey: Constant.defaultBalanceStr) ?? Constant.naStr)
        
        if self.cosmosWalletAddress != "" {
            self._isRefreshVisible = State(initialValue: true)
        }
        
        print(isRefreshVisible)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Cosmos Wallet Address")
                .bold()
            
            TextField("Enter Cosmos Wallet Address",
                      text: $cosmosWalletAddress,
                      onCommit:{
                        self.isRefreshVisible = false
                        self.balance = Constant.fetchingBalanceStr
                        callAPI()
                        self.isSaveVisible = true
                      })
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Balance: \(balance)")
            
            if [Constant.naStr, Constant.fetchingBalanceStr].contains(balance)
                &&
                isSaveVisible {
                
                Button("Save Address") {
                    defaults.set(cosmosWalletAddress, forKey: Constant.defaultWalletAddressStr)
                    defaults.set(balance, forKey: Constant.defaultBalanceStr)
                    
                    showSaveAlert = true
                }.alert(isPresented: $showSaveAlert) {
                    Alert(title: Text("Info Saved"),
                          message: Text("Your Wallet Address has been saved."),
                          dismissButton: .default(Text("OK")){
                            isSaveVisible = false
                            isRefreshVisible = true
                          })
                }
            }
            
            if isRefreshVisible {
                Button("Refresh") {
                    balance = Constant.fetchingBalanceStr
                    callAPI()
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    func callAPI() {
        Api(cosmosWalletAddress: self.cosmosWalletAddress)
            .loadData{
                balance in self.balance = balance
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LikeCoinBalanceSettings()
    }
}
