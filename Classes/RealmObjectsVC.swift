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

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.setup()
    }

    func setup() {
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        //self.tableView.backgroundColor = UIColor(red: 0.23, green: 0.29, blue: 0.48, alpha: 1.00)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
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

