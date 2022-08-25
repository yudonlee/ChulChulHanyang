//
//  WidgetView.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/16.
//

import WidgetKit
import SwiftUI
import Intents


struct ChulChulHanyangWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var entry: Provider.Entry
    var type: RestaurantType
    
    var body: some View {
        widgetBody()
    }
    
    @ViewBuilder
    func widgetBody() -> some View {
        switch family {
        case .systemSmall:
            WidgetSmallView(type: type)
        case .systemMedium:
            Text("Test")
        default:
            EmptyView()
            
        }
    }
    
}



struct WidgetSmallView: View {
    
    var type: RestaurantType
    var menu: [String]  {
        return ParsingManager.parsing(type: type)
    }
    
    var body: some View {
        VStack{
            Text("\(type.name)").font(.system(size: 12, weight: .bold))
            if !menu.isEmpty {
                ForEach(menu, id: \.self) { food in
                    Text(food).font(.system(size: 13, weight: .medium))
                }
            } else {
                Text("해당 식당은 오늘 운영하지 않아요😢").font(.system(size: 13, weight: .medium))
            }
        }
    }
}
