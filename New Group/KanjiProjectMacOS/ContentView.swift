//
//  ContentView.swift
//  KanjiProjectMacOS
//
//  Created by ブラック狼 on 2024/12/01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            let i = TestFile()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
