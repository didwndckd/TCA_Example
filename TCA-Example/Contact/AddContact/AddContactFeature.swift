//
//  AddContactFeature.swift
//  TCA-Example
//
//  Created by yjc on 8/18/26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddContactFeature {
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)
    }
    
    // @Shared로 부모의 데이터를 공유, 처리하는 방법도 있음
    enum Delegate: Equatable {
//        case cancel
        case saveContact(Contact)
    }
    
    @Dependency(\.dismiss)
    private var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                // delegate -> cancel을 send
//                return .send(.delegate(.cancel))
                return .run { _ in await self.dismiss() }
            case .saveButtonTapped:
                // delegate -> saveContact를 send
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                }
            case .setName(let name):
                state.contact.name = name
                return .none
            case .delegate:
                // 호출부에 위임이라 여기서 할일이 없음
                return .none
            }
        }
    }
}
