//
//  UserDefaults.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 12.09.2021.
//

import Foundation
import Combine

@propertyWrapper
struct CodableDefaults<T: Codable> {
    
    private let key: String
    private let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let encoded = UserDefaults.standard.value(forKey: key) as? Data,
                  let result = try? JSONDecoder().decode(T.self, from: encoded) else {
                      return defaultValue
                  }
            return result
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}
