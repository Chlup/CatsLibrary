//
//  GridViewController.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Combine
import Foundation
import UIKit

class GridViewController: UIViewController {
    private struct Dependencies {
        let logger = DI.getLogger()
    }

    enum Section: Hashable {
        case main
    }

    private let deps = Dependencies()
    private let viewModel: GridViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, DataItem>?
    private var cancellables: [AnyCancellable] = []
    private var items: [DataItem] = []

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        navigationItem.title = "Enjoy cats"

        setupCollectionView()
        setupDataSource()

        loadData()
    }

    private func setupCollectionView() {
        let nib = UINib(nibName: "CatGridCell", bundle: nil)
        grid.register(nib, forCellWithReuseIdentifier: "CatGridCell")

        if let layout = grid.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing: CGFloat = 10
            let itemWidth = (view.frame.size.width - (4 * spacing)) / 3
            let itemHeight = itemWidth * 1.2

            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        }
    }

    private func setupDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<Section, DataItem>(collectionView: grid) { collectionView, indexPath, item in
            let finalCell: UICollectionViewCell
            switch item {
            case let .cat(cat):
                let possibleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatGridCell", for: indexPath)
                guard let cell = possibleCell as? CatGridCell else {
                    fatalError("Expecting to create cell with type CatGridcell but has \(possibleCell)")
                }

                if cell.image.url != cat.imageURL {
                    cell.image.cancel()
                }

                cell.title.text = cat.name
                cell.image.placeholderView = UIActivityIndicatorView()
                cell.image.url = cat.imageURL
                cell.image.imageView.contentMode = .scaleAspectFill
                cell.item = item
                finalCell = cell
            }

            return finalCell
        }
        self.dataSource = dataSource
        grid.dataSource = dataSource
    }

    private func update(with item: DataItem) {
        self.items.append(item)
        var snapshot = NSDiffableDataSourceSnapshot<Section, DataItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    @objc
    private func reloadData() {
        cancellables = []
        loadData()
    }

    private func loadData() {
        items = []
        viewModel.loadData()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.deps.logger.debug("Data loading finished.")

                    case let .failure(error):
                        self?.deps.logger.debug("Data loading failed with error: \(error)")
                        self?.handleLoading(error: error)
                    }
                },
                receiveValue: { [weak self] item in
                    self?.update(with: item)
                }
            )
            .store(in: &cancellables)
    }

    private func handleLoading(error: ErrorMessage) {
        let alert = UIAlertController(title: "Data loading error", message: error.description, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "Reload", style: .default) { [weak self] _ in self?.reloadData() }
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(reloadAction)
        alert.addAction(okAction)

        present(alert, animated: true)
    }
}

extension GridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(item: items[indexPath.row])
    }
}
