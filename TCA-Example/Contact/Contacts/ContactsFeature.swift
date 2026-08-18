//
//  ContactsFeature.swift
//  TCA-Example
//
//  Created by yjc on 8/18/26.
//

import Foundation
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                let contact = Contact(id: UUID(), name: "")
                state.addContact = AddContactFeature.State(contact: contact)
                return .none
                
//            case .addContact(.presented(.delegate(.cancel))):
//                // AddContactView -> 닫기 이벤트 들어왔을 때
//                state.addContact = nil
//                return .none
                
            case .addContact(.presented(.delegate(.saveContact(let contact)))):
                // AddContactView -> Save 버튼 눌렀을 때
//                guard let contact = state.addContact?.contact else { return .none }
                
                state.contacts.append(contact)
//                state.addContact = nil
                return .none
                
            case .addContact:
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactFeature()
        }
    }
}
