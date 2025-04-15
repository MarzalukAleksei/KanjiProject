//
//  CoordinatorView.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2025/04/13.
//

import SwiftUI

struct CoordinatorView: View {
    let firstPage: Page
    @StateObject var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: firstPage)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}
