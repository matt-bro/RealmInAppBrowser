//
//  RealmObjectsVC.swift
//  RealmInAppBrowser
//
//  Created by Matt on 06.10.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import UIKit
import RealmSwift

internal class RealmObjectsVC: UITableViewController {

    var store: RealmStore? {
        didSet {
            self.store?.update()
            self.tableView.reloadData()
        }
    }

    var closeBtn: UIBarButtonItem {
        UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(pressedClose(_:)))
    }

    var pressedCloseAction:(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = closeBtn

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func setup() {
        self.tableView.backgroundColor = UIColor(red: 0.23, green: 0.29, blue: 0.48, alpha: 1.00)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
        func insertNewObject(_ sender: Any) {
            let realm = try! Realm()

            let object = Person()
            let randomNumber = Int.random(in: 1000...9999)
            object.id = "\(randomNumber)"
            object.firstName = "firstName \(randomNumber)"
            object.lastName = "lastName \(randomNumber)"
            object.address = "Address \(Int.random(in: 100...999))"
            object.phone = "+00 \(Int.random(in: 10000...99999))"
            object.mobile = "+00 \(Int.random(in: 10000...99999))"
            object.birthdate = Date()


            let todo = Todo()
            todo.id = "\(randomNumber)"
            todo.title = "Title \(Int.random(in: 100...999))"
            todo.dueDate = Date()
            todo.done = (randomNumber > 5000)

            object.todos.append(todo)
            try! realm.write {
                realm.add(object)
                realm.add(todo)
            }
            self.tableView.reloadData()
        }

    @objc func pressedClose(_ sender: UIBarButtonItem) {
        self.pressedCloseAction?()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store?.classNames.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let className = self.store?.className(index: indexPath.row)
        cell.textLabel?.text = className
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let objectName = self.store?.className(index: indexPath.row) else {
            return
        }

        store?.queryObject = objectName
        store?.update()
        //let entries = RealmController.shared.entries(for: objectName)

        if let nvc = self.splitViewController?.viewControllers.last as? UINavigationController {
            let controller = RealmBrowserVC()
            controller.store = store
            //TODO: Differ between iPad and iPhone
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                nvc.pushViewController(controller, animated: true)
            case .pad:
                nvc.setViewControllers([controller], animated: false)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            default:
                print("RIAB - Couldn't figure out how to push view")
                return
            }
        }
    }
}

