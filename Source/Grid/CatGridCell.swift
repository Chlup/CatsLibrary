//
//  GridCell.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import NukeUI
import Foundation
import UIKit

class CatGridCell: UICollectionViewCell {
    @IBOutlet var image: LazyImageView!
    @IBOutlet var title: UILabel!
    var item: DataItem?
}
