//
//  CounterFeature.swift
//  TCA-Example
//
//  Created by yjc on 8/9/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action {
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case incrementButtonTapped
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelID {
        case timer
    }
    
    @Dependency(\.continuousClock) private var clock
    @Dependency(\.numberFact) private var numberFact
    
    var body: some ReducerOf<Self> { // some Reducer<State, Action>와 같음
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                return .run(
                    operation: { [count = state.count] send in
                        let fact = try await self.numberFact.fetch(count)
                        await send(.factResponse(fact))
                        
                        // 이렇게도 가능
//                        try await send(.factResponse(self.numberFact.fetch(count)))
                    },
                    catch: { error, send in
                        let message = "❌ERROR: \(error.localizedDescription)"
                        await send(.factResponse(message))
                    })
                
            case .factResponse(let fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    // 타이머 돌리기 with CancelID
                    return .run(
                        operation: { send in
                            for await _ in self.clock.timer(interval: .seconds(1)) {
                                await send(.timerTick)
                            }
                        },
                        catch: { error, send in
                            print("Timer run error: \(error)")
                        }
                    )
                    .cancellable(id: CancelID.timer)
                            
                } else {
                    // 타이머 돌리던거 취소
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}
