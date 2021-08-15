//
//  LikeCoinBalanceWidget.swift
//  LikeCoinBalanceWidget
//
//  Created by Juan on 17/07/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),  balance: UserDefaults(suiteName: Config.suitNameStr)!.string(forKey: Constant.defaultBalanceStr) ?? "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),  balance: UserDefaults(suiteName: Config.suitNameStr)!.string(forKey: Constant.defaultBalanceStr) ?? "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        
        print("Date(): \(Date())")
        
        print("entryDate: \(entryDate)")
        
        Api(cosmosWalletAddress: UserDefaults(suiteName: Config.suitNameStr)!.string(forKey: Constant.defaultWalletAddressStr) ?? "")
            .loadData {
                balance in UserDefaults(suiteName: Config.suitNameStr)!.set(balance, forKey: Constant.defaultBalanceStr)
                
                let entry = SimpleEntry(date: entryDate,  balance: balance)
                entries.append(entry)

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let balance: String
}

struct LikeCoinBalanceWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        EmojiWidgetView(likeCoinAccount: LikeCoinAccount(balance: entry.balance))
    }
}

@main
struct LikeCoinBalanceWidget: Widget {
    let kind: String = "LikeCoinBalanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LikeCoinBalanceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("LikeCoin Balance")
        .description("Display Current LikeCoin Account Balance")
        .supportedFamilies([.systemSmall])
    }
}

struct LikeCoinBalanceWidget_Previews: PreviewProvider {
        
    static var previews: some View {
        LikeCoinBalanceWidgetEntryView(
            entry: SimpleEntry(date: Date(), balance: UserDefaults(suiteName: Config.suitNameStr)!.string(forKey: Constant.defaultBalanceStr) ?? ""))
                               .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
