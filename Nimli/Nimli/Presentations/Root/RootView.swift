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
    @EnvironmentObject var router: NimliAppRouter
    var body: some View {
        SignUpView()
    }
}
