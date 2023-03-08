//
//  Model+CoreDataProperties.swift
//  Counter
//
//  Created by Данила on 22.02.2023.
//
//

import CoreData
import RxDataSources

@objc public enum CounterType: Int16 {
    case classic
    case minimal
    case timeCounter
}

extension Model {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: "Model")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var count: Int64
    @NSManaged public var value: Int16
    @NSManaged public var isPlus: Bool
    @NSManaged public var index: Int16
    
    @NSManaged public var type: CounterType
}

extension Model: IdentifiableType {
    public typealias Identity = UUID
    
    public var identity: UUID {
        return id
    }
}
