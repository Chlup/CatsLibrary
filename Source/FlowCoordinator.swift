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
    struct Dependencies {
        let logger = DI.getLogger()
    }

    private let deps = Dependencies()
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
        deps.logger.debug("Show detail for \(item)")

        let flow = DetailFlow(
            close: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        let viewModel = DetailViewModelImpl(item: item, flow: flow)
        let controller = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
