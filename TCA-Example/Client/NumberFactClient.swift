//
//  NumberFactClient.swift
//  TCA-Example
//
//  Created by yjc on 8/17/26.
//

import Foundation
import ComposableArchitecture

struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self(
        fetch: { number in
            let url = URL(string: "http://number-trivia.com/\(number)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
