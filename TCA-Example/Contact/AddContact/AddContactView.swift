//
//  AddContactView.swift
//  TCA-Example
//
//  Created by yjc on 8/18/26.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    // iOS 17 이상: @Bindable / iOS 17 미만: @Perception.Bindabl
    @Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        Form {
            TextField("Name", text: $store.contact.name.sending(\.setName))
            Button("Save") { store.send(.saveButtonTapped) }
        }
        .toolbar {
            ToolbarItem { cancelButton }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            store.send(.cancelButtonTapped)
        }
    }
}

#Preview {
    let contact = Contact(id: UUID(), name: "yjc")
    let state = AddContactFeature.State(contact: contact)
    let store = Store(initialState: state) { AddContactFeature()}
    NavigationStack {
        AddContactView(store: store)
    }
}
