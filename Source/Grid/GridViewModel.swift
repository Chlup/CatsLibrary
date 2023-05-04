//
//  GridViewModel.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Foundation

struct GridFlow {
    let didSelectCat: (Cat) -> Void
}

protocol GridViewModel {

}

class GridViewModelImpl {
    let flow: GridFlow

    init(flow: GridFlow) {
        self.flow = flow
    }
}

extension GridViewModelImpl: GridViewModel {
    
}
