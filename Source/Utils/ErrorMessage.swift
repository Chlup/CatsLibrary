//
//  Errors.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Foundation

struct ErrorMessage: Error, CustomStringConvertible {
    let code: ErrorCode
    let message: String

    var description: String {
        return "\(message) (\(code.rawValue))"
    }
}

enum ErrorCode: String {
    case cantLoadLocalData = "CL00001"
}
