//
//  CatServiceProtocol.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 15.09.2021.
//

import Foundation
import UIKit
import Combine

protocol CatServiceProtocol {
    func randomKitty(saying phrase: String) -> AnyPublisher<UIImage, Error>
}
