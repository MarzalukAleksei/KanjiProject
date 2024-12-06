//
//  UserActivityView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2024/12/05.
//

import SwiftUI

struct UserActivityView: View {
    let userActivity: [Date]
    let rows: [GridItem] = .init(repeating: GridItem(.fixed(ElementSize.userActivityCellSize.width),
                                                     spacing: Settings.paddingBetweenText - 1),
                                 count: Settings.userActivityIndicatorRows)
    
    var body: some View {
        ScrollViewReader { proxy in
            GeometryReader { geo in
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows) {
                        ForEach(0..<Settings.elementsInUserActivityIndicator, id: \.self) { cell in
                            Cell(sameDate: .random())
                                .frame(width: ElementSize.userActivityCellSize.width,
                                       height: ElementSize.userActivityCellSize.height)
                                .id(cell)
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
            }
            .onAppear {
                scrollToLast(proxy: proxy)
            }
        }
        .frame(height: ElementSize.userActivityCellSize.width * CGFloat(Settings.userActivityIndicatorRows) + Settings.paddingBetweenText * CGFloat(Settings.userActivityIndicatorRows))
    }
    
    private func setCell() {
        guard let lastDate = userActivity.last else { return }
        let calendar = Calendar.current
        
    }
    
    private func scrollToLast(proxy: ScrollViewProxy) {
        proxy.scrollTo(Settings.elementsInUserActivityIndicator - 1)
    }
}

#Preview {
    UserActivityView(userActivity: [.now])
}

private struct Cell: View {
    let sameDate: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: Settings.userActivityCellCornerRadius)
                    .foregroundStyle(sameDate ? Color.green.opacity(0.7) : Color.gray.opacity(0.5))
                RoundedRectangle(cornerRadius: Settings.userActivityCellCornerRadius)
                    .stroke(lineWidth: 2)
            }
            .padding(1)
        }
    }
}
