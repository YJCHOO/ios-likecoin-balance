//
//  Api.swift
//  LikeCoinBalance
//
//  Created by Juan on 17/07/2021.
//

import Foundation

public class Api: ObservableObject {
    
    let walletAddress: String
    
    init(cosmosWalletAddress: String) {
        walletAddress = cosmosWalletAddress
    }
    
    func loadData(completion: @escaping (String) -> ()) {
        guard let url = URL(string: "http://192.168.1.11:5000/wallet?address=" + walletAddress) else {
            print("Invalid url...")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            var likeCoin = LikeCoinAccount(balance: Constant.naStr)
            if error == nil {
                likeCoin = try! JSONDecoder().decode(LikeCoinAccount.self, from: data!)
                print(likeCoin)
            } else {
                let defaultBalance = UserDefaults(suiteName: "group.com.juan.LikeCoinBalance")?.string(forKey: Constant.defaultBalanceStr) ?? ""
                if defaultBalance != "" {
                    likeCoin.balance = defaultBalance
                }
            }
            
            DispatchQueue.main.async {
                completion(likeCoin.balance)
            }
        }.resume()
    }
}
