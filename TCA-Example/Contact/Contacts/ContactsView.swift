//
//  ContactsView.swift
//  TCA-Example
//
//  Created by yjc on 8/18/26.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            list
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem { plusButton }
            }
        }
        .sheet(item: $store.scope(\.addContact, action: \.addContact)) { addContactStore in
            addContactView(store: addContactStore)
        }
    }
    
    private var list: some View {
        List {
            ForEach(store.contacts) { contact in
                Text(contact.name)
            }
        }
    }
    
    private var plusButton: some View {
        Button(
            action: {
                store.send(.addButtonTapped)
            },
            label: {
                Image(systemName: "plus")
            }
        )
    }
    
    private func addContactView(store: StoreOf<AddContactFeature>) -> some View {
        NavigationStack {
            AddContactView(store: store)
        }
    }
}

#Preview {
    ContactsView(
        store: Store(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(id: UUID(), name: "Blob"),
                    Contact(id: UUID(), name: "Blob Jr"),
                    Contact(id: UUID(), name: "Blob Sr"),
                ]
            )
        ) {
            ContactsFeature()
        }
    )
}
