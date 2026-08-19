//
//  ContactDetailView.swift
//  TCA-Example
//
//  Created by yjc on 8/20/26.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
    @Bindable var store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        Form {
            Button("Delete") {
                store.send(.deleteButtonTapped)
            }
        }
        .navigationTitle(Text(store.contact.name))
        .alert($store.scope(\.alert, action: \.alert))
    }
}

#Preview {
    let contact = Contact(id: UUID(), name: "yjc")
    let store = Store(
        initialState: ContactDetailFeature.State(contact: contact),
        reducer: { ContactDetailFeature() }
    )
    NavigationStack {
        ContactDetailView(store: store)
    }
}
