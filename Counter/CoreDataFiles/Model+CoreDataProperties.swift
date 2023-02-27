//
//  Model+CoreDataProperties.swift
//  Counter
//
//  Created by Данила on 22.02.2023.
//
//

import Foundation
import CoreData
import RxDataSources


extension Model {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: "Model")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var count: Int64
    
}

extension Model: IdentifiableType {
    public typealias Identity = UUID
    
    public var identity: UUID {
        return id
    }
}
