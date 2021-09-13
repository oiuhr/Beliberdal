//
//  TransformerResult+CoreDataProperties.swift
//  beliberdal
//
//  Created by Ryzhov Eugene on 13.09.2021.
//
//

import Foundation
import CoreData


extension TransformerResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransformerResult> {
        return NSFetchRequest<TransformerResult>(entityName: "TransformerResult")
    }

    @NSManaged public var result: String?
    @NSManaged public var transformerName: String?
    @NSManaged public var id: UUID?

}

extension TransformerResult : Identifiable {

}
