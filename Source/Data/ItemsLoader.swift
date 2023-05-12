//
//  LocalStorage.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Combine
import Foundation

extension DI {
    static let getItemsLoader = bind(ItemsLoader.self) { ItemsLoaderImpl.shared }
}

enum DataItem: Hashable, Sendable {
    case cat(Cat)
}

protocol ItemsLoader {
    func loadData() -> AnyPublisher<DataItem, ErrorMessage>
}

private class ItemsLoaderImpl {
    fileprivate static let shared = ItemsLoaderImpl()

    private enum Constants {
        static let names: [String] = [
            "Luna", "Charlie", "Bella", "Simba", "Milo", "Ciri", "Tris", "Daisy", "Max", "Loki", "Leo", "Oliver", "Lucy", "Tiger", "Nala"
        ]
        static let numbersOfCatsToLoad = 10
    }

    private struct CatInfo: Codable {
        let url: String
    }

    init() { }

    private func downloadCatInfo(_ url: URL) -> AnyPublisher<CatInfo, ErrorMessage> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw ErrorMessage(code: .invalidNetworkResponse, message: "Received invalid http response.", underlyingError: nil)
                }

                guard httpResponse.statusCode == 200 else {
                    throw ErrorMessage(code: .wrongHTTPCode, message: "Received \(httpResponse.statusCode) for url \(url)", underlyingError: nil)
                }
                return element.data
            }
            .decode(type: CatInfo.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? ErrorMessage {
                    return error
                } else {
                    return ErrorMessage(code: .cantDecodeData, message: "Can't decode data for url \(url)", underlyingError: error)
                }
            }
            .eraseToAnyPublisher()
    }
}

extension ItemsLoaderImpl: ItemsLoader {
    func loadData() -> AnyPublisher<DataItem, ErrorMessage> {
        return Deferred {
            let urls: [URL] = (0..<Constants.numbersOfCatsToLoad).compactMap { _ in
                guard let dataURL = URL(string: "https://cataas.com/cat?json=true") else { return nil }
                return dataURL
            }

            let publishers: [AnyPublisher<DataItem, ErrorMessage>] = urls
                .map { url in
                    return self.downloadCatInfo(url)
                        .tryMap { catInfo in
                            guard let imageURL = URL(string: "https://cataas.com\(catInfo.url)") else {
                                throw ErrorMessage(
                                        code: .invalidImageURL,
                                        message: "Fetched image URL is invalid \(catInfo.url)",
                                        underlyingError: nil
                                    )
                            }

                            let name = Constants.names[Int.random(in: 0..<Constants.names.count)]
                            return DataItem.cat(Cat(id: UUID().uuidString, name: name, imageURL: imageURL))
                        }
                        .mapError { error in
                            if let error = error as? ErrorMessage {
                                return error
                            } else {
                                return ErrorMessage(code: .invalidImageURL, message: "Invalid cat image URL.", underlyingError: error)
                            }
                        }
                        .eraseToAnyPublisher()
                }

            return Publishers.MergeMany(publishers).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
