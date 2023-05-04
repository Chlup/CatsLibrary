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
    let underlyingError: Error?

    var description: String {
        return "\(message) (\(code.rawValue))"
    }
}

enum ErrorCode: String {
    case wrongHTTPCode = "CL0001"
    case invalidNetworkResponse = "CL0002"
    case cantDecodeData = "CL0003"
    case invalidImageURL = "CL0004"
}
