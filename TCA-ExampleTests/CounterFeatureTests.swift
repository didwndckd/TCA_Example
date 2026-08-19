//
//  TCA_ExampleTests.swift
//  TCA-ExampleTests
//
//  Created by yjc on 8/9/26.
//

import Testing
import ComposableArchitecture
@testable import TCA_Example

@MainActor
struct CounterFeatureTests {
    @Test
    func basics() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
    
    @Test
    func timer() async {
        let clock = TestClock()
        
        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() },
            withDependencies: {
                $0.continuousClock = clock
            }
        )
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        
//        // 내부 타이머가 1초이기 때문에 명시적으로 타임아웃 2초 -> 실제 내부 타이머가 돌아서 완료 될 때 까지 최대 2초 기다려야 해서 좋지 않음
//        await store.receive(\.timerTick, timeout: .seconds(2)) {
//            $0.count = 1
//        }
        
        // TestClock을 사용해서 추상적으로 1초 지난것으로 만듬
        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    @Test
    func numberFac() async {
        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() },
            withDependencies: {
                $0.numberFact.fetch = { "\($0) is a good number." }
            }
        )
        
        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.factResponse) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
}
