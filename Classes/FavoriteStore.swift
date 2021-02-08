//
//  FavoriteStore.swift
//  Pods
//
//  Created by Matt on 01.02.21.
//

import UIKit
import RealmSwift

internal class FavoriteStore: StoreProtocol {
    var queryObject: Any?
    weak var delegate: StoreDelegate?

    var config: Realm.Configuration {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("RIABFavorites.realm")
        return config
    }

    var objects:[Favorite] = []

    func update() {
        let realm = try! Realm(configuration: config)

        if let objectName = queryObject as? String {
            self.objects = Array(realm.objects(Favorite.self).filter("objectName == '\(objectName)'"))
        } else {
            //self.objects = Array(realm.objects(Favorite.self))
        }

        self.delegate?.didUpdate(store: self, isEmpty: self.objects.isEmpty, hasError: false)
    }

    func add(query: String, objectName:String? = nil) {
        let realm = try! Realm(configuration: config)

        let favorite = Favorite()
        favorite.id = "\(Int.random(in: 999999..<9999999))"
        favorite.query = query
        favorite.objectName = (objectName == nil) ? (self.queryObject as! String) : objectName!

        try! realm.write {
            realm.add(favorite)
        }
        self.update()
    }

    func remove(id: String) {
        let realm = try! Realm(configuration: config)
        let favorite = realm.objects(Favorite.self).filter("id == '\(id)'")
        try! realm.write {
            realm.delete(favorite)
        }
        self.update()
    }
}

internal class Favorite: Object {
    @objc dynamic var id = ""
    @objc dynamic var objectName = ""
    @objc dynamic var query = ""

    override class func primaryKey() -> String {
        return "id"
    }
}

