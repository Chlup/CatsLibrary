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
    func showDetailController(for cat: Cat)
}

private class FlowCoordinatorImpl {
    static let shared = FlowCoordinatorImpl()

    var navigationController: UINavigationController?

    init() { }
}

extension FlowCoordinatorImpl: FlowCoordinator {
    func makeRootController() -> UIViewController {
        let flow = GridFlow(
            didSelectCat: { [weak self] cat in
                self?.showDetailController(for: cat)
            }
        )
        let viewModel = GridViewModelImpl(flow: flow)

        let gridController = GridViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: gridController)
        self.navigationController = navigationController
        return navigationController
    }

    func showDetailController(for cat: Cat) {
        print("Show detail for \(cat)")
    }


}
