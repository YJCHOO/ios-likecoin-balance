//
//  LikeCoinBalanceWidgetView.swift
//  LikeCoinBalanceWidgetExtension
//
//  Created by Juan on 17/07/2021.
//

import SwiftUI

struct EmojiWidgetView: View {
    let likeCoinAccount: LikeCoinAccount
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 40/255, green: 100/255, blue: 110/255, alpha: 1))
            VStack(alignment: .leading){
                Text("LikeCoin: ")
                    .font(.title3)
                    .foregroundColor(.white)
                Text(likeCoinAccount.balance)
                    .padding(.top, 0.5)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
    
}
