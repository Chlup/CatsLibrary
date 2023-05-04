//
//  DetailViewModel.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Combine
import Foundation

struct DetailFlow {
    let close: () -> Void
}

protocol DetailViewModel {
    func loadData() -> AnyPublisher<LocalItem, Never>
    func close()
}

class DetailViewModelImpl {
    let item: LocalItem
    let flow: DetailFlow

    init(item: LocalItem, flow: DetailFlow) {
        self.item = item
        self.flow = flow
    }
}

extension DetailViewModelImpl: DetailViewModel {
    func loadData() -> AnyPublisher<LocalItem, Never> {
        return Just(item).eraseToAnyPublisher()

    }

    func close() {
        flow.close()
    }
}

