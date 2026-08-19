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
        var contacts: IdentifiedArrayOf<Contact> = []
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case addButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped(id: Contact.ID)
        
        @CasePathable
        enum Alert: Equatable {
            case confirmDeletetion(id: Contact.ID)
        }
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                let contact = Contact(id: self.uuid(), name: "")
                let addContactState = AddContactFeature.State(contact: contact)
                state.destination = .addContact(addContactState)
                return .none
                
            case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
                state.contacts.append(contact)
                return .none
                
            case .destination(.presented(.alert(.confirmDeletetion(id: let id)))):
                state.contacts.remove(id: id)
                return .none
                
            case .destination:
                return .none
                
            case .deleteButtonTapped(id: let id):
                state.destination = .alert(.deleteConfirmation(id: id))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
    }
}

extension ContactsFeature {
    @Reducer
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
}

extension ContactsFeature.Destination.State: Equatable {}

extension AlertState where Action == ContactsFeature.Action.Alert {
    static func deleteConfirmation(id: UUID) -> Self {
        Self(
            title: {
                TextState("Are you sure?")
            },
            actions: {
                ButtonState(
                    role: .destructive,
                    action: .confirmDeletetion(id: id),
                    label: {
                        TextState("Delete")
                    }
                )
            }
        )
    }
}
