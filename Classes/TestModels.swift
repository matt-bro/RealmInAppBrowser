//
//  TestModels.swift
//  RealmInAppBrowser
//
//  Created by Matt on 06.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var mobile: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var birthdate: Date?
    @objc dynamic var todo: Todo?
    var todos = List<Todo>()

    override class func primaryKey() -> String? {
        return "id"
    }
}

class Todo: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var dueDate: Date?
    @objc dynamic var done: Bool = false

    override class func primaryKey() -> String? {
        return "id"
    }
}

class TestModels {

    static func createModels() {
        let realm = try! Realm()
        if realm.objects(Person.self).isEmpty {
            var objects: [Object] = []

            for _ in 0..<10 {
                objects.append(createPerson(realm: realm))
            }

            for _ in 0..<10 {
                objects.append(createTodo(realm: realm))
            }
        }
    }

    static func createPerson(realm:Realm) -> Person {
        let object = Person()
        let randomNumber = Int.random(in: 1000...9999)
        object.id = "\(randomNumber)"
        object.firstName = "firstName \(randomNumber)"
        object.lastName = "lastName \(randomNumber)"
        object.address = "Address \(Int.random(in: 100...999))"
        object.phone = "+00 \(Int.random(in: 10000...99999))"
        object.mobile = "+00 \(Int.random(in: 10000...99999))"
        object.birthdate = Date()
        return object
    }

    static func createTodo(realm:Realm) -> Todo {
        let todo = Todo()
        let randomNumber = Int.random(in: 1000...9999)
        todo.id = "\(randomNumber)"
        todo.title = "Title \(Int.random(in: 100...999))"
        todo.dueDate = Date()
        todo.done = (randomNumber > 5000)
        return todo
    }
}


