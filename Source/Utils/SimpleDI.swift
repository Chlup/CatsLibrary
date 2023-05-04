//
//  SimpleDI.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

/// Based on Lyfts SimpleDI. More info:
/// https://www.youtube.com/watch?v=dA9rGQRwHGs
/// https://noahgilmore.com/blog/swift-dependency-injection/

import Foundation

private var instantiators: [String: Any] = [:]
private var mockInstantiators: [String: Any] = [:]
private var lock = NSRecursiveLock()

public enum DI {
    public static let isTestEnvironment = false

    public static func mock<T>(_ type: T.Type, instantiator: @escaping () -> T) {
        lock.lock()
        mockInstantiators[String(describing: type)] = instantiator
        lock.unlock()
    }

    public static func isMocked<T>(_ type: T.Type) -> Bool {
        lock.lock()
        let isMocked = mockInstantiators.keys.contains(String(describing: type))
        lock.unlock()
        return isMocked
    }

    public static func unmock<T>(_ type: T.Type) {
        lock.lock()
        mockInstantiators[String(describing: type)] = nil
        lock.unlock()
    }

    public static func unmockAll() {
        lock.lock()
        mockInstantiators = [:]
        lock.unlock()
    }

    /// Bind some type to instantiator closure.
    ///
    /// - Parameters:
    ///   - type: Type of instance.
    ///   - instantiator: Closure which creates instance of `type`.
    /// - Returns: Instantiator.
    public static func bind<T>(_ type: T.Type, instantiator: @escaping () -> T) -> () -> T {
        lock.lock()
        instantiators[String(describing: type)] = instantiator
        lock.unlock()
        return self.instance
    }

    // MARK: - Private API
    private static func instance<T>() -> T {
        let key = String(describing: T.self)
        if self.isTestEnvironment {
            guard let instantiator = mockInstantiators[key] as? () -> T else {
                fatalError("Type \(key) unmocked in test!")
            }
            return instantiator()
        }
        lock.lock()
        let instantiator = instantiators[key] as! () -> T
        lock.unlock()
        return instantiator()
    }
}
