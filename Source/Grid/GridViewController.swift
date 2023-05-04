//
//  GridViewController.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Foundation
import UIKit

class GridViewController: UIViewController {
    let viewModel: GridViewModel

    @IBOutlet var grid: UICollectionView!

    init(viewModel: GridViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "GridViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
