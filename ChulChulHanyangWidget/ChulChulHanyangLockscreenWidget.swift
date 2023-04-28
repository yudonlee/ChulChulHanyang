//
//  ChulChulHanyangLockscreenWidget.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2023/04/04.
//

import WidgetKit
import SwiftUI
import Intents


struct LockscreenProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> LockscreenSimpleEntry {
        LockscreenSimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (LockscreenSimpleEntry) -> ()) {
        let entry = LockscreenSimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [LockscreenSimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = LockscreenSimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct LockscreenSimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}


@available(iOS 16.0, *)
struct ChulChulHanyangWidgetLockscreen: WidgetBundle {
    var body: some Widget {
        HangwonParkLockscreenWidget()
        HanyangPlazaLockscreenWidget()
        HumanEcologyLockscreenWidget()
        MaterialScienceLockscreenWidget()
        ResidenceOneLockscreenWidget()
        ResidenceTwoLockscreenWidget()
    }
}

@available(iOS 16.0, *)
struct HangwonParkLockscreenWidget: Widget {
    let kind: String = "HangwonParkLockscreenWidget"
    
    @Environment(\.widgetFamily) var family
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LockscreenProvider()) { entry in
            LockscreenView(entry: entry, type: .HangwonPark)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .HangwonPark, widgetType: .lockscreenWidget))
        }
        .supportedFamilies([.accessoryCircular])
        .configurationDisplayName("행원 파크 식당")
        .description("위젯 클릭시 행원 파크 식당 메뉴로 이동합니다. ")
    }
}


@available(iOS 16.0, *)
struct HanyangPlazaLockscreenWidget: Widget {
    let kind: String = "HanyangPlazaLockscreenWidget"
    
    @Environment(\.widgetFamily) var family
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LockscreenProvider()) { entry in
            LockscreenView(entry: entry, type: .HanyangPlaza)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .HanyangPlaza, widgetType: .lockscreenWidget))
        }
        .supportedFamilies([.accessoryCircular])
        .configurationDisplayName("한양 플라자 학생 식당")
        .description("위젯 클릭시 한양 플라자 학생 식당 메뉴로 이동합니다. ")
    }
}


@available(iOS 16.0, *)
struct HumanEcologyLockscreenWidget: Widget {
    let kind: String = "HumanEcologyLockscreenWidget"
    
    @Environment(\.widgetFamily) var family
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LockscreenProvider()) { entry in
            LockscreenView(entry: entry, type: .HumanEcology)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .HumanEcology, widgetType: .lockscreenWidget))
        }
        .supportedFamilies([.accessoryCircular])
        .configurationDisplayName("생과대 교직원 식당")
        .description("위젯 클릭시 생과대 교직원 식당 메뉴로 이동합니다. ")
    }
}

@available(iOS 16.0, *)
struct MaterialScienceLockscreenWidget: Widget {
    let kind: String = "MaterialScienceLockscreenWidget"
    
    @Environment(\.widgetFamily) var family
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LockscreenProvider()) { entry in
            LockscreenView(entry: entry, type: .MaterialScience)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .MaterialScience, widgetType: .lockscreenWidget))
        }
        .supportedFamilies([.accessoryCircular])
        .configurationDisplayName("신소재 교직원 식당")
        .description("위젯 클릭시 신소재 교직원 식당 메뉴로 이동합니다. ")
    }
}

@available(iOS 16.0, *)
struct ResidenceOneLockscreenWidget: Widget {
    let kind: String = "ResidenceOneLockscreenWidget"
    
    @Environment(\.widgetFamily) var family
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LockscreenProvider()) { entry in
            LockscreenView(entry: entry, type: .ResidenceOne)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .ResidenceOne, widgetType: .lockscreenWidget))
        }
        .supportedFamilies([.accessoryCircular])
        .configurationDisplayName("제 1생활관 식당 위젯")
        .description("위젯 클릭시 제 1생활관 식당 메뉴로 이동합니다. ")
    }
}

@available(iOS 16.0, *)
struct ResidenceTwoLockscreenWidget: Widget {
    let kind: String = "ResidenceTwoLockscreenWidget"
    
    @Environment(\.widgetFamily) var family
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: LockscreenProvider()) { entry in
            LockscreenView(entry: entry, type: .ResidenceTwo)
                .widgetURL(URLConstants.makeWidgetDeeplink(restaurant: .ResidenceTwo, widgetType: .lockscreenWidget))
        }
        .supportedFamilies([.accessoryCircular])
        .configurationDisplayName("제 2생활관 식당 위젯")
        .description("위젯 클릭시 제 2생활관 식당 메뉴로 이동합니다. ")
    }
}



@available(iOS 16.0, *)
struct LockscreenView: View {
    var entry: LockscreenProvider.Entry
    var type: RestaurantType
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack{
                Spacer()
                Image("lockscreenWidgetRiceImage")
                    .resizable()
                    .scaledToFit()
                Text("출출하냥")
                    .font(.system(size: 8))
                Spacer()
            }
        }
    }
}
