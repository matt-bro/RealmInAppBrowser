//
//  RealmController.swift
//  RealmInAppBrowser
//
//  Created by Matt on 25.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import Foundation
import RealmSwift



class RealmController {
    static var shared = RealmController()

    var objectNames:[String] = []
    var schema: Schema?
    var classNames:[String] {
        return self.schema?.objectSchema.map({$0.className}) ?? []
    }

 
    func propertyNames(for className:String) -> [String] {
        let realm = try! Realm()
        return realm.schema.objectSchema.filter({$0.className == className}).first?.properties.map({$0.name}) ?? []
    }

    func setup() {
        let realm = try! Realm()
        self.schema = realm.schema
    }

    func tables() {
        let realm = try! Realm()
        //print(realm.configuration)

        //realm.configuration.customSchema?.objectSchema.map({$0.className})

        print(realm.schema.objectSchema.map({$0.className}))
        self.objectNames = realm.schema.objectSchema.map({$0.className})
    }

    func entries(for objectName:String) -> [DynamicObject] {
        let realm = try! Realm()
        let objects = realm.dynamicObjects(objectName)
        //print(objects.first!.value(forKey: "firstName"))

        if let object = objects.first {
            let propertyNameStrings:[String] = propertyNames(for: objectName)
            print("\n---- \(objectName)")
            for property in propertyNameStrings {
                print("property: \(property) with value \(object.value(forKey: property) ?? "none")")
            }
            print("----\n\n")
        }

        return Array(realm.dynamicObjects(objectName))
    }
}

