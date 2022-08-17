//
//  ChulChulHanyangWidget.swift
//  ChulChulHanyangWidget
//
//  Created by yudonlee on 2022/08/16.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffSet in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffSet, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}


struct ChulChulHanyangWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var entry: Provider.Entry
    var menu: [String]  {
        guard let data = CrawlManager.shared.crawlRestaurantMenu(date: Date(), restaurantType: .HumanEcology) else {
            return [String]()
        }
        
        var mealData = data.filter { str in
            str.contains("중식")
        }.flatMap({ $0 })

        guard let pangeosIndex = mealData.firstIndex(of: "[Pangeos]") else { return mealData }

//        UserDefaults.setVale
        let range = pangeosIndex..<mealData.endIndex
        mealData.removeSubrange(range)
        return mealData
    }
        
    var body: some View {
        widgetBody()
    }
    
    @ViewBuilder
    func widgetBody() -> some View {
        switch family {
        case .systemSmall:
            HStack{
                VStack{
                    ForEach(menu, id: \.self) { food in
                        Text(food).font(.system(size: 13, weight: .medium))
                    }
                }
            }
        case .systemMedium:
            HStack{
                VStack{
                    ForEach(menu, id: \.self) { food in
                        Text(food).font(.system(size: 13, weight: .medium))
                    }
                }
                VStack{
                    ForEach(menu, id: \.self) { food in
                        Text(food).font(.system(size: 13, weight: .medium))
                    }
                }
                VStack{
                    ForEach(menu, id: \.self) { food in
                        Text(food).font(.system(size: 13, weight: .medium))
                    }
                }
            }
        default:
            EmptyView()
            
        }
    }
}


@main
struct ChulChulHanyangWidget: Widget {
    let kind: String = "ChulChulHanyangWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct ChulChulHanyangWidget_Previews: PreviewProvider {
    static var previews: some View {
        ChulChulHanyangWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
