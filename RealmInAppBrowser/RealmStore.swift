//
//  RealmStore.swift
//  RealmInAppBrowser
//
//  Created by Matt on 30.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import UIKit
import RealmSwift

protocol StoreProtocol {
    var queryObject: Any? {get set}
    var delegate: StoreDelegate? {get set}
    func update()
}

protocol StoreDelegate: class {
    func willUpdate(store: StoreProtocol)
    func didUpdate(store: StoreProtocol, isEmpty: Bool, hasError: Bool)
}

extension StoreDelegate {
    func willUpdate(store: StoreProtocol) {}
    func didUpdate(store: StoreProtocol, isEmpty: Bool, hasError: Bool) {}
}

class RealmStore: NSObject, StoreProtocol {

    var queryObject: Any?
    private var realm: Realm?
    private var schema: Schema?
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

        self.loadedObjectProperties = realm.schema.objectSchema.filter({$0.className == className }).first?.properties ?? []

        let objects = realm.dynamicObjects(className)

        self.delegate?.didUpdate(store: self, isEmpty: objects.isEmpty, hasError: false)
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
    var propertyCount: Int {
        loadedObjectProperties.count
    }

    func get() -> DynamicObject? {
        nil
    }

    //TODO: sort need to consider the type in the future
//    func sort(for propertyName: String) {
//        if objects.isEmpty { return }
//
//        var ascending = false
//
//        if let sortingBy = sortingBy {
//            if sortingBy.name == propertyName {
//                ascending = !sortingBy.asc
//                self.sortingBy = (propertyName, ascending)
//            } else {
//                self.sortingBy = (propertyName, ascending)
//            }
//        } else {
//            self.sortingBy = (propertyName, ascending)
//        }
//        //check if property exists
//        self.objects.sort(by: {
//            if let val1 = $0.value(forUndefinedKey: propertyName) as? String, let val2 = $1.value(forUndefinedKey: propertyName) as? String {
//                if ascending { return val1 < val2 } else { return val1 > val2 }
//            }
//            return true
//        })
//
//        self.collectionVC?.collectionView.reloadData()
//    }

    func filter() {

    }

}
