//
//  Logger.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import Foundation

extension DI {
    static let getLogger = bind(Logger.self) { LoggerImpl.shared }
}

protocol Logger {
    func debug(_ message: String)
}

private class LoggerImpl: Logger {
    static let shared = LoggerImpl()
    init() { }
    func debug(_ message: String) {
    #if DEBUG
        print(message)
    #endif
    }
}
