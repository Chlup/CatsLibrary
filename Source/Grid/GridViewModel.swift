//
//  GridViewModel.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Combine
import Foundation

struct GridFlow {
    let didSelectItem: (LocalItem) -> Void
}

protocol GridViewModel {
    func loadData() -> AnyPublisher<[LocalItem], ErrorMessage>
    func didSelect(item: LocalItem)
}

class GridViewModelImpl {
    private struct Depedencies {
        let localStorage = DI.getLocalStorage()
    }
    private let deps = Depedencies()
    let flow: GridFlow

    init(flow: GridFlow) {
        self.flow = flow
    }
}

extension GridViewModelImpl: GridViewModel {
    func loadData() -> AnyPublisher<[LocalItem], ErrorMessage> {
        return deps.localStorage.loadData()
    }

    func didSelect(item: LocalItem) {
        flow.didSelectItem(item)
    }
}
