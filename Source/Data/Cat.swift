//
//  Cat.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Foundation

struct Cat: Hashable, Sendable {
    let id: String
    let name: String
    let imageURL: URL
}
