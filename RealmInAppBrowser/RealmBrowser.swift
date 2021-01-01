//
//  CustomSplitViewController.swift
//  RealmInAppBrowser
//
//  Created by Matt on 06.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import Foundation
import UIKit

class RealmInAppBrowser: UISplitViewController, UISplitViewControllerDelegate {

    var masterVC: UIViewController?
    var detailVC: UIViewController?

    var pressedCloseAction: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible

        let store = RealmStore()
        let masterVC = RealmObjectsVC(style: .plain)
        masterVC.store = store

        if pressedCloseAction != nil {
            masterVC.pressedCloseAction = pressedCloseAction
        } else {
            masterVC.pressedCloseAction = { self.dismiss(animated: true , completion: nil) }
        }
        let detailVC = RealmBrowserVC()
        detailVC.store = store

        self.masterVC = masterVC
        self.detailVC = detailVC

        let detailNVC = UINavigationController(rootViewController: detailVC)
        detailNVC.setNavigationBarHidden(true, animated: false)
        self.viewControllers = [UINavigationController(rootViewController: masterVC), detailNVC]

        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

    func splitViewController(
             _ splitViewController: UISplitViewController,
             collapseSecondary secondaryViewController: UIViewController,
             onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }
}
