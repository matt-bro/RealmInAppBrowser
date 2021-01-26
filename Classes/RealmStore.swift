//
//  RealmStore.swift
//  RealmInAppBrowser
//
//  Created by Matt on 30.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import UIKit
import RealmSwift


internal protocol StoreProtocol {
    var queryObject: Any? {get set}
    var delegate: StoreDelegate? {get set}
    func update()
}

internal protocol StoreDelegate: class {
    func willUpdate(store: StoreProtocol)
    func didUpdate(store: StoreProtocol, isEmpty: Bool, hasError: Bool)
    func didFilter(withError: String)
}

internal extension StoreDelegate {
    func willUpdate(store: StoreProtocol) {}
    func didUpdate(store: StoreProtocol, isEmpty: Bool, hasError: Bool) {}
    func didFilter(withError: String) {}
}

internal class RealmStore: NSObject, StoreProtocol {

    var queryObject: Any?
    private var realm: Realm?
    private var schema: Schema?
    private var objects: [DynamicObject] = []
    private var filteredObjects: [DynamicObject] = []
    var isFiltering: Bool {
        return filteredObjects.isEmpty == false
    }
    private var results: Results<DynamicObject>?
    weak var delegate: StoreDelegate?
    var sortingBy: (name: String, asc: Bool)?

    var classNames:[String] {
        return self.schema?.objectSchema.map({$0.className}) ?? []
    }

    private var objectSchemas:[ObjectSchema] {
        return self.schema?.objectSchema ?? []
    }

    init(realm: Realm) {
        super.init()
        self.realm = realm
        self.setup()
    }

    override init() {
        super.init()
        do {
            self.realm = try Realm()
            self.setup()
        } catch {
            print("RealmStore - could not init Realm")
        }
    }

    func setup() {
        self.schema = self.realm?.schema
    }

    func update() {
        self.delegate?.willUpdate(store: self)

        guard let realm = realm, let className = queryObject as? String else { return }

        self.reset()
        self.loadedObjectProperties = realm.schema.objectSchema.filter({$0.className == className }).first?.properties ?? []

        let objects = realm.dynamicObjects(className)
        self.objects = Array(objects)
        self.results = objects

        self.delegate?.didUpdate(store: self, isEmpty: objects.isEmpty, hasError: false)
    }

    func reset() {
        self.sortingBy = nil
        self.filteredObjects = []
        self.objects = []
        self.loadedObjectProperties = []
        self.loadedObjectProperties = []
    }

    func schema(index: Int) -> ObjectSchema? {
        guard objectSchemas.isEmpty == false, (index >= 0 && index < objectSchemas.count) else {
            return nil
        }
        return objectSchemas[index]
    }

    func className(index: Int) -> String? {
        let classNames = self.classNames
        guard classNames.isEmpty == false, (index >= 0 && index < classNames.count) else {
            return nil
        }

        return classNames[index]
    }

    // MARK: LOADING AN OBJECT
    var loadedObjectProperties: [Property] = []

    func propertyName(index: Int) -> String {
        loadedObjectProperties[index].name
    }

    func propertyType(index: Int) -> String {
        return loadedObjectProperties[index].type.name
        //loadedObjectProperties[index].objectClassName ?? ""
    }

    var propertyCount: Int {
        loadedObjectProperties.count
    }
    var objectCount: Int {
        if isFiltering {
            return self.filteredObjects.count
        }
        return self.objects.count
    }

    func get(index: Int) -> Property? {
        return self.loadedObjectProperties[index]
    }

    func get(index: Int) -> DynamicObject? {
        guard self.objects.isEmpty == false, (index >= 0 && index < self.objects.count) else {
            return nil
        }

        if isFiltering {
            return self.filteredObjects[index]
        }

        return self.objects[index]
    }

    func value(propertyIndex: Int, objectIndex: Int) -> String? {
        let property = self.loadedObjectProperties[propertyIndex]
        var object = self.objects[objectIndex]
        if isFiltering {
            object = self.filteredObjects[objectIndex]
        }

        switch property.type {
        case .bool:
            if let value = object.value(forKey: property.name) as? Bool {
                return value.description
            }
        case .date:
            if let value = object.value(forKey: property.name) as? Date {
                return value.description
            }
        //case .linkingObjects, .object, .objectId:
            // TODO: enable relations
//            if let value = object.value(forKey: property.name) as? Object {
//                return value.description
//            }
//
//            if let value = object.value(forKey: property.name) as? List<RealmCollectionValue> {
//                return value.description
//            }


        default:
            if let value = object.value(forKey: property.name) as? String {
                return value.description
            }
        }


        return nil
    }

    func sort(for propertyName: String) {
        var objects = isFiltering ? self.filteredObjects : self.objects

        if objects.isEmpty { return }

        var ascending = false

        if let sortingBy = sortingBy {
            if sortingBy.name == propertyName {
                ascending = !sortingBy.asc
                self.sortingBy = (propertyName, ascending)
            } else {
                self.sortingBy = (propertyName, ascending)
            }
        } else {
            self.sortingBy = (propertyName, ascending)
        }

        objects.sort(by: {
            if let val1 = $0.value(forUndefinedKey: propertyName) as? String, let val2 = $1.value(forUndefinedKey: propertyName) as? String {
                if ascending { return val1 < val2 } else { return val1 > val2 }
            }
            return true
        })

        if isFiltering {
            self.filteredObjects = objects
        } else {
            self.objects = objects
        }

        self.delegate?.didUpdate(store: self, isEmpty: objects.isEmpty, hasError: false)
    }

    func filter(query: String) {
        guard let results = results else {
            return
        }

        // TODO: try to validate query and handle exception
        // can't use bridging header in pods
        self.filteredObjects = Array(results.filter(query))
        self.delegate?.didUpdate(store: self, isEmpty: self.filteredObjects.isEmpty, hasError: false)
//        do {
//            try ObjC.catchException {
//                self.filteredObjects = Array(results.filter(query))
//                self.delegate?.didUpdate(store: self, isEmpty: self.filteredObjects.isEmpty, hasError: false)
//            }
//        } catch {
//            self.delegate?.didFilter(withError: error.localizedDescription )
//        }

    }


    func resetFilter() {
        self.filteredObjects = []
        self.delegate?.didUpdate(store: self, isEmpty: self.objects.isEmpty, hasError: false)
    }

}

extension PropertyType {
    var name: String {
        switch self.rawValue {
        case 0: return "Int"
        case 1: return "Bool"
        case 2: return "String"
        case 3: return "Data"
        case 4: return "Date"
        case 5: return "Float"
        case 6: return "Double"
        case 7: return "Object"
        case 8: return "LinkingObject"
        case 9: return "Any"
        case 10: return "ObjectId"
        case 11: return "Decimal128"
        default:
            return ""
        }
    }
}
