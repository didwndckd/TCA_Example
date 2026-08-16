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
    struct State {
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
                        let url = URL(string: "http://number-trivia.com/\(count)")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let fact = String(decoding: data, as: UTF8.self)
                        await send(.factResponse(fact))
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
                            while true {
                                try await Task.sleep(for: .seconds(1))
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
