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

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate!))
        completion(timeline)
        
        
        
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}




@main
struct ChulChulHanyangWidget: WidgetBundle {
    var body: some Widget {
        HumanEcologyWidget()
        MaterialScienceWidget()
        ResidenceOneWidget()
        ResidenceTwoWidget()
        ChulChulHanyangWidgetOthers().body
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
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .HumanEcology)
        }
        .configurationDisplayName("생과대 교직원 식당")
        .description("해당 메뉴들은 시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다. 이때 생과대에서 중식은 두개의 식당이 제공되는데, 이중 Dam-A식당만이 위젯에 나타납니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct MaterialScienceWidget: Widget {
    let kind: String = "MaterialScienceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .MaterialScience)
        }
        .configurationDisplayName("신소재 교직원 식당")
        .description("해당 메뉴들은 시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다. 이때 신소재에서 중식은 두개의 식당이 제공되는데, 이중 정식식당 만이 위젯에 나타납니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct ResidenceOneWidget: Widget {
    let kind: String = "ResidenceOneWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .ResidenceOne)
        }
        .configurationDisplayName("제 1생활관 식당 위젯")
        .description("시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct ResidenceTwoWidget: Widget {
    let kind: String = "ResidenceTwoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .ResidenceTwo)
        }
        .configurationDisplayName("제 2생활관 식당 위젯")
        .description("시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다.")
        .supportedFamilies([.systemSmall])
    }
}


struct HanyangPlazaWidget: Widget {
    let kind: String = "HanyangPlazaWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .HanyangPlaza)
        }
        .configurationDisplayName("학생 식당")
        .description("한플 학생식당에선 라면을 제외한 모든 메뉴가 보여집니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct HangwonParkWidget: Widget {
    let kind: String = "HangwonParkWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ChulChulHanyangWidgetEntryView(entry: entry, type: .HangwonPark)
        }
        .configurationDisplayName("행원파크 식당")
        .description("시간에 맞춰 조식, 중식, 석식 메뉴가 보여집니다. 중식 메뉴에선 두개의 식당 중 코너 A에서 제공되는 메뉴만 보여집니다.")
        .supportedFamilies([.systemSmall])
    }
}
