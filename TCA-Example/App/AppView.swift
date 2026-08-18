//
//  AppView.swift
//  TCA-Example
//
//  Created by yjc on 8/18/26.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        TabView {
            CounterView(store: store.scope(\.tab1, action: \.tab1))
                .tabItem { Text("Counter 1") }
            
            CounterView(store: store.scope(\.tab2, action: \.tab2))
                .tabItem { Text("Counter 2") }
            
            ContactsView(store: store.scope(\.tab3, action: \.tab3))
                .tabItem { Text("Counter 3") }
        }
    }
}

#Preview {
    AppView(
        store: StoreOf<AppFeature>(initialState: AppFeature.State()) { AppFeature() }
    )
}
