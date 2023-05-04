//
//  LocalStorage.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Combine
import Foundation

extension DI {
    static let getLocalStorage = bind(LocalStorage.self) { LocalStorageImpl.shared }
}

protocol LocalStorage {
    func loadData() -> AnyPublisher<[Cat], Error>
}

private class LocalStorageImpl {
    fileprivate static let shared = LocalStorageImpl()

    private enum Constants {
        static let names: [String] = [
            "Luna", "Charlie", "Bella", "Simba", "Milo", "Ciri", "Tris", "Daisy", "Max", "Loki", "Leo", "Oliver", "Lucy", "Tiger", "Nala"
        ]
        static let numbersOfCatsToLoad = 1000
    }

    init() { }
}

extension LocalStorageImpl: LocalStorage {
    func loadData() -> AnyPublisher<[Cat], Error> {
        let rnd = Int.random(in: 0...100)
        // 5% chance that loading of data fails. This is just simulation because there is no real data loading.
        guard rnd > 5 else {
            return Fail(error: ErrorMessage(code: .cantLoadLocalData, message: "Failed to load data from local storage.")).eraseToAnyPublisher()
        }

        return Deferred {
            let cats: [Cat] = (0..<Constants.numbersOfCatsToLoad).compactMap { _ in
                let name = Constants.names[Int.random(in: 0..<Constants.names.count)]
                guard let imageURL = URL(string: "https://cataas.com/cat") else { return nil }
                return Cat(id: UUID().uuidString, name: name, imageURL: imageURL)
            }

            return Just(cats)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
