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

enum LocalItem: Hashable, Sendable {
    case cat(Cat)
}

protocol LocalStorage {
    func loadData() -> AnyPublisher<[LocalItem], ErrorMessage>
}

private class LocalStorageImpl {
    fileprivate static let shared = LocalStorageImpl()

    private enum Constants {
        static let names: [String] = [
            "Luna", "Charlie", "Bella", "Simba", "Milo", "Ciri", "Tris", "Daisy", "Max", "Loki", "Leo", "Oliver", "Lucy", "Tiger", "Nala"
        ]
        static let numbersOfCatsToLoad = 100
    }

    init() { }
}

extension LocalStorageImpl: LocalStorage {
    func loadData() -> AnyPublisher<[LocalItem], ErrorMessage> {
        let rnd = Int.random(in: 0...100)
        // 5% chance that loading of data fails. This is just simulation because there is no real data loading.
        guard rnd > 5 else {
            return Fail(error: ErrorMessage(code: .cantLoadLocalData, message: "Failed to load data from local storage.")).eraseToAnyPublisher()
        }

        return Deferred {
            let cats: [LocalItem] = (0..<Constants.numbersOfCatsToLoad).compactMap { _ in
                let id = UUID().uuidString
                let name = Constants.names[Int.random(in: 0..<Constants.names.count)]
                // id param for this URL isn't required but the API returns random image for each API call. And by adding name parameter it's possible
                // to use local cache and be sure that one image is used for one name even when name is used multiple times.
                guard let imageURL = URL(string: "https://cataas.com/cat?id=\(name)") else { return nil }
                return .cat(Cat(id: id, name: name, imageURL: imageURL))
            }

            return Just(cats)
                .setFailureType(to: ErrorMessage.self)
                .eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
