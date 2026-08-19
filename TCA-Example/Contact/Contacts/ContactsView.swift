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
        .sheet(item: $store.scope(\.$destination, action: \.destination).addContact) { addContactStore in
            addContactView(store: addContactStore)
        }
        .alert($store.scope(\.$destination, action: \.destination).alert) { value in
            guard let value else { return }
            store.send(.destination(.presented(.alert(value))))
        }
//        .alert($store.scope(\.alert, action: \.alert)) <- deprecated 되었다고 나옴
    }
    
    private var list: some View {
        List {
            ForEach(store.contacts) { contact in
                row(contact)
            }
        }
    }
    
    private func row(_ contact: Contact) -> some View {
        HStack {
            Text(contact.name)
            Spacer()
            Button {
                store.send(.deleteButtonTapped(id: contact.id))
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
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
