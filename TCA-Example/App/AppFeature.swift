//
//  AppFeature.swift
//  TCA-Example
//
//  Created by yjc on 8/18/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
        var tab3 = ContactsFeature.State()
    }
    
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
        case tab3(ContactsFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(\.tab1, action: \.tab1) { CounterFeature() }
        Scope(\.tab2, action: \.tab2) { CounterFeature() }
        Scope(\.tab3, action: \.tab3) { ContactsFeature() }
        Reduce { state, action in
            // AppFeature 자체의 로직
            return .none
        }
    }
}
