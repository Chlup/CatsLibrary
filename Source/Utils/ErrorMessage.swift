//
//  Errors.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Foundation

struct ErrorMessage: Error {
    let code: ErrorCode
    let message: String
}

enum ErrorCode: String {
    case cantLoadLocalData = "CL00001"
}
