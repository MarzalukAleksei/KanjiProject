//
//  UserActivityView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/05.
//

import SwiftUI

struct UserActivityView: View {
    let userActivity: [Date]
    private let rows: [GridItem] = .init(repeating: GridItem(.fixed(ElementSize.userActivityCellSize.width),
                                                     spacing: Settings.paddingBetweenText - 1),
                                 count: Settings.userActivityIndicatorRows)
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHGrid(rows: rows, spacing: Settings.paddingInUserActivity) {
                    let dates = dates()
                    ForEach(0..<Settings.elementsInUserActivityIndicator, id: \.self) { cell in
                        let dateType = typeOfDate(of: dates, by: cell)
                        Cell(dateType: dateType)
                            .frame(width: ElementSize.userActivityCellSize.width,
                                   height: ElementSize.userActivityCellSize.height)
                            .id(cell)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onAppear {
                scrollToLast(proxy: proxy)
            }
        }
        .frame(height: ElementSize.userActivityCellSize.width * CGFloat(Settings.userActivityIndicatorRows) + Settings.paddingInUserActivity * CGFloat(Settings.userActivityIndicatorRows))
    }
    
    private func dates(maxDay: Int = Settings.elementsInUserActivityIndicator) -> [Date] {
        var result: [Date] = []
        for day in 0..<maxDay {
            guard let date = setCellDate(id: day) else { return result }
            result.append(date)
        }
        return result
    }
    
    private func setCellDate(id: Int) -> Date? {
        let calendar = Calendar.current
        let searchedDate = calendar.date(byAdding: .day, value: -Settings.elementsInUserActivityIndicator + (id + 1), to: Date.now)
        return searchedDate
    }
    
    private func typeOfDate(of dates: [Date], by index: Int) -> DateCondition {
        let currentCellDate = dates[index]
        let currentCellComponents = UserActivity.getDateComponents(for: currentCellDate)
        
        if currentCellDate < userActivity[0] {
            return .dateBeforeFirstActivity
        }
        
        for activity in userActivity {
            let activityComp = UserActivity.getDateComponents(for: activity)
            if currentCellComponents == activityComp {
                return .confirmedActivity
            }
        }
        
        return .dateWithoutActivity
    }
    
    private func scrollToLast(proxy: ScrollViewProxy) {
        proxy.scrollTo(Settings.elementsInUserActivityIndicator - 1)
    }
}

#Preview {
    UserActivityView(userActivity: [.now])
}

private struct Cell: View {
    let dateType: DateCondition
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Settings.userActivityCellCornerRadius)
                .foregroundStyle(setColor())
            RoundedRectangle(cornerRadius: Settings.userActivityCellCornerRadius)
                .stroke(lineWidth: 2)
                .opacity(dateType == .dateBeforeFirstActivity ? 0.3 : 1)
        }
        .padding(1)
    }
    
    private func setColor() -> Color {
        switch dateType {
        case .dateBeforeFirstActivity:
            return .white
        case .confirmedActivity:
            return .green.opacity(0.7)
        case .dateWithoutActivity:
            return .gray.opacity(0.5)
        }
    }
}

private enum DateCondition {
    case dateBeforeFirstActivity
    case confirmedActivity
    case dateWithoutActivity
}
