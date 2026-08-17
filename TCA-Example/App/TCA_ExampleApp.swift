//
//  TCA_ExampleApp.swift
//  TCA-Example
//
//  Created by yjc on 8/9/26.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_ExampleApp: App {
    private let store = StoreOf<AppFeature>(initialState: AppFeature.State()) { AppFeature()._printChanges() }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}

