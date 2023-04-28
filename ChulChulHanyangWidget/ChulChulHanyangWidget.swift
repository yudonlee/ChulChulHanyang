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
    let type: RestaurantType
    
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), data: [])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        ParsingManager.parsingAsync(type: type) { result in
            switch result {
            case .success(let data):
                let entry = SimpleEntry(date: Date(), configuration: configuration, data: data)
                completion(entry)
            case .failure(let error):
                let entry = SimpleEntry(date: Date(), configuration: configuration, data: [])
                completion(entry)
            }
        }
        
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        
        ParsingManager.parsingAsync(type: type) { result in
            switch result {
            case .success(let data):
                let entry = SimpleEntry(date: Date(), configuration: configuration, data: data)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            case .failure(let error):
                let entry = SimpleEntry(date: Date(), configuration: configuration, data: [])
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            }
        }
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let data: [String]
}


@main
struct ChulChulHanyangWidget: WidgetBundle {
    var body: some Widget {
        HumanEcologyWidget()
        MaterialScienceWidget()
        ResidenceOneWidget()
        ResidenceTwoWidget()
        ChulChulHanyangWidgetOthers().body
        if #available(iOS 16.0, *) {
            ChulChulHanyangWidgetLockscreen().body
        }
    }
}

struct ChulChulHanyangWidgetOthers: WidgetBundle {
    var body: some Widget {
        HanyangPlazaWidget()
        HangwonParkWidget()
    }
}






struct HumanEcologyWidget: Widget {
    let kind: String = "HumanEcologyWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(type: .HumanEcology)) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .HumanEcology)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .HumanEcology, widgetType: .smallWidget))
        }
        .configurationDisplayName("생과대 교직원 식당")
        .description("해당 메뉴들은 시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다. 이때 생과대에서 중식은 두개의 식당이 제공되는데, 이중 Dam-A식당만이 위젯에 나타납니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct MaterialScienceWidget: Widget {
    let kind: String = "MaterialScienceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(type: .MaterialScience)) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .MaterialScience)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .MaterialScience, widgetType: .smallWidget))
        }
        .configurationDisplayName("신소재 교직원 식당")
        .description("해당 메뉴들은 시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다. 이때 신소재에서 중식은 두개의 식당이 제공되는데, 이중 정식식당 만이 위젯에 나타납니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct ResidenceOneWidget: Widget {
    let kind: String = "ResidenceOneWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(type: .ResidenceOne)) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .ResidenceOne)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .ResidenceOne, widgetType: .smallWidget))
        }
        .configurationDisplayName("제 1생활관 식당 위젯")
        .description("시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct ResidenceTwoWidget: Widget {
    let kind: String = "ResidenceTwoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(type: .ResidenceTwo)) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .ResidenceTwo)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .ResidenceTwo, widgetType: .smallWidget))
        }
        .configurationDisplayName("제 2생활관 식당 위젯")
        .description("시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다.")
        .supportedFamilies([.systemSmall])
    }
}


struct HanyangPlazaWidget: Widget {
    let kind: String = "HanyangPlazaWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(type: .HanyangPlaza)) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .HanyangPlaza)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .HanyangPlaza, widgetType: .smallWidget))
        }
        .configurationDisplayName("학생 식당")
        .description("한플 학생식당에선 라면을 제외한 모든 메뉴가 보여집니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct HangwonParkWidget: Widget {
    let kind: String = "HangwonParkWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(type: .HangwonPark)) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .HangwonPark)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .HangwonPark, widgetType: .smallWidget))
        }
        .configurationDisplayName("행원파크 식당")
        .description("행원 파크는 중식 메뉴만 보여집니다. 이때 교직원 식당 메뉴만 제공됩니다.")
        .supportedFamilies([.systemSmall])
    }
}
