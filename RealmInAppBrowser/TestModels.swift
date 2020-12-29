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

    override class func primaryKey() -> String? {
        return "id"
    }
}
