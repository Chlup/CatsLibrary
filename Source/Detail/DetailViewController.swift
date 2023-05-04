//
//  DetailViewController.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Combine
import Foundation
import NukeUI
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var name: UILabel!
    @IBOutlet var image: LazyImageView!

    private let viewModel: DetailViewModel
    private var cancellables: [AnyCancellable] = []

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "Loading..."
        image.imageView.contentMode = .scaleAspectFill
        image.placeholderView = UIActivityIndicatorView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables = []
    }

    private func loadData() {
        viewModel.loadData()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] item in
                    self?.updateUI(with: item)
                }
            )
            .store(in: &cancellables)
    }

    private func updateUI(with item: LocalItem) {
        switch item {
        case let .cat(cat):
            name.text = cat.name
            image.url = cat.imageURL
        }
    }
}
