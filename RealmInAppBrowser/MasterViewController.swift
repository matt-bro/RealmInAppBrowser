//
//  MasterViewController.swift
//  RealmInAppBrowser
//
//  Created by Matt on 06.10.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

    var detailViewController: UIViewController? = nil
    var objects = [Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RealmBrowserVC
        }

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        RealmController.shared.tables()
        self.objects = RealmController.shared.objectNames
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)

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
        try! realm.write {
            realm.add(object)
        }

        self.tableView.reloadData()

    }

//    // MARK: - Segues
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let objectName = self.objects[indexPath.row] as! String
//                let entries = RealmController.shared.entries(for: objectName)
//                //let object = objects[indexPath.row] as! NSDate
//                let nvc = (segue.destination as! UINavigationController)
//                let controller = RealmBrowserVC()
//                controller.headers = RealmController.shared.propertyNames(for: objectName)
//                controller.objects = entries
//                nvc.setViewControllers([controller], animated: false)
//                //controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                detailViewController = controller
//            }
//        }
//    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row] as! String
        cell.textLabel!.text = object
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objectName = self.objects[indexPath.row] as! String
        let entries = RealmController.shared.entries(for: objectName)

        if let nvc = self.splitViewController?.viewControllers.last as? UINavigationController {
            let controller = RealmBrowserVC()
            controller.headers = RealmController.shared.propertyNames(for: objectName)
            controller.objects = entries

            //TODO: Differ between iPad and iPhone

            detailViewController = controller
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

