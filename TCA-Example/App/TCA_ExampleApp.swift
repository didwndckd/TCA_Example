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
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges() // 리듀서의 모든 액션과 처리 후 상태 변화를 출력
    }
    var body: some Scene {
        WindowGroup {
            CounterView(store: TCA_ExampleApp.store)
        }
    }
}
