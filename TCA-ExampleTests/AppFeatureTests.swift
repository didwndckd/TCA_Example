//
//  AppFeatureTests.swift
//  TCA-ExampleTests
//
//  Created by yjc on 8/18/26.
//

import ComposableArchitecture
import Testing

@testable import TCA_Example

@MainActor
struct AppFeatureTests {
    @Test
    func incrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) { AppFeature() }
        
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
    }
}
