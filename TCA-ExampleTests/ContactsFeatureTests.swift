//
//  ContactsFeatureTests.swift
//  TCA-ExampleTests
//
//  Created by yjc on 8/19/26.
//

import Foundation
import Testing
import ComposableArchitecture

@testable import TCA_Example

@MainActor
struct ContactsFeatureTests {
    @Test
    func addFlow() async {
        let store = TestStore(
            initialState: ContactsFeature.State(),
            reducer: { ContactsFeature() },
            withDependencies: {
                $0.uuid = .incrementing
            }
        )
        
        // 추가 버튼 누름
        await store.send(.addButtonTapped) {
            let contact = Contact(id: UUID(0), name: "")
            let state = AddContactFeature.State(contact: contact)
            $0.destination = .addContact(state)
        }
        
        // AddContactFeature에서 텍스트 수정
        await store.send(\.destination.addContact.setName, "Blob Jr.") {
            $0.destination.modify(\.addContact, yield: { $0.contact.name = "Blob Jr." })
        }
        
        // AddContactFeature에서 Save 버튼 클릭
        await store.send(\.destination.addContact.saveButtonTapped)
        
        // 이벤트 수신
        await store.receive(
            \.destination.addContact.delegate.saveContact,
             Contact(id: UUID(0), name: "Blob Jr.")
        ) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
        }
        
        // 화면이 잘 닫아졌는지 확인
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
    
    // 위 addFlow는 effact가 발생시킨 모든 액션이 Store에 수신되는 과정까지 하나하나 검증해야 한다(ex: dismiss 빼면 테스트 실패함)
    @Test
    func addFlowNonExhaustive() async {
        let store = TestStore(
            initialState: ContactsFeature.State(),
            reducer: { ContactsFeature() },
            withDependencies: {
                $0.uuid = .incrementing
            }
        )
        store.exhaustivity = .off // Non-Exhaustive: 모든 이벤트를 검증하지 않아도 됨
        
        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName, "Blob Jr.")
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.skipReceivedActions() // receive 액션들을 건너뜀
        
        // 최종 상태만 검증
        store.assert {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
            $0.destination = nil
        }
    }

    @Test
    func deleteContact() async {
        let state = ContactsFeature.State(
            contacts: [
                Contact(id: UUID(0), name: "Blob"),
                Contact(id: UUID(1), name: "Blob Jr."),
            ]
        )
        let store = TestStore(
            initialState: state,
            reducer: { ContactsFeature() }
        )
        
        // 삭제 버튼 클릭 해서 Alert 띄우는지 확인
        await store.send(.deleteButtonTapped(id: UUID(1))) {
//            let alertState = AlertState(
//                title: { TextState("Are you sure?") },
//                actions: {
//                    ButtonState(role: .destructive, action: ContactsFeature.Action.Alert.confirmDeletetion(id: UUID(1))) {
//                        TextState("Delete")
//                    }
//                }
//            )
            $0.destination = .alert(.deleteConfirmation(id: UUID(1)))
        }
        
        // 콜백시 처리 검증
        await store.send(\.destination.alert.confirmDeletetion, UUID(1)) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob"),
            ]
            $0.destination = nil
        }
    }
}
