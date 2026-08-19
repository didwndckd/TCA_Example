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
        @Presents var alert: AlertState<Action.Alert>?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
        case alert(PresentationAction<Alert>)
        case deleteButtonTapped(id: Contact.ID)
        
        enum Alert: Equatable {
            case confirmDeletetion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                let contact = Contact(id: UUID(), name: "")
                state.addContact = AddContactFeature.State(contact: contact)
                return .none
                
//            case .addContact(.presented(.delegate(.cancel))):
//                // AddContactView -> 닫기 이벤트 콜백
//                state.addContact = nil
//                return .none
                
            case .addContact(.presented(.delegate(.saveContact(let contact)))):
                // AddContactView -> Save 버튼 눌렀을 때 콜백
//                guard let contact = state.addContact?.contact else { return .none }
                
                state.contacts.append(contact)
//                state.addContact = nil
                return .none
                
            case .addContact:
                return .none
                
            case .alert(.presented(.confirmDeletetion(id: let id))):
                // Alert의 콜백
                state.contacts.remove(id: id)
                return .none
            
            case .alert:
                return .none
                
            case .deleteButtonTapped(id: let id):
                state.alert = AlertState(
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
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) { // AddContactView 띄울 때
            AddContactFeature()
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
