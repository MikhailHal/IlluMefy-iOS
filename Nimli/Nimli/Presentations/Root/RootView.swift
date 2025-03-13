//
//  ContentView.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/09.
//  Test

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
