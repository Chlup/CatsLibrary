//
//  GridViewModel.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Combine
import Foundation

struct GridFlow {
    let didSelectItem: (DataItem) -> Void
}

protocol GridViewModel {
    func loadData() -> AnyPublisher<DataItem, ErrorMessage>
    func didSelect(item: DataItem)
}

class GridViewModelImpl {
    private struct Depedencies {
        let itemsLoader = DI.getItemsLoader()
    }
    private let deps = Depedencies()
    let flow: GridFlow

    init(flow: GridFlow) {
        self.flow = flow
    }
}

extension GridViewModelImpl: GridViewModel {
    func loadData() -> AnyPublisher<DataItem, ErrorMessage> {
        return deps.itemsLoader.loadData()
    }

    func didSelect(item: DataItem) {
        flow.didSelectItem(item)
    }
}
