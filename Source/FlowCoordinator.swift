//
//  FlowCoordinator.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Foundation
import UIKit

extension DI {
    static let getFlowCoordinator = bind(FlowCoordinator.self) { FlowCoordinatorImpl.shared }
}

protocol FlowCoordinator {
    func makeRootController() -> UIViewController
    func showDetailController(for item: LocalItem)
}

private class FlowCoordinatorImpl {
    static let shared = FlowCoordinatorImpl()

    var navigationController: UINavigationController?

    init() { }
}

extension FlowCoordinatorImpl: FlowCoordinator {
    func makeRootController() -> UIViewController {
        let flow = GridFlow(
            didSelectItem: { [weak self] item in
                self?.showDetailController(for: item)
            }
        )
        let viewModel = GridViewModelImpl(flow: flow)

        let gridController = GridViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: gridController)
        self.navigationController = navigationController
        return navigationController
    }

    func showDetailController(for item: LocalItem) {
        print("Show detail for \(item)")
    }


}
