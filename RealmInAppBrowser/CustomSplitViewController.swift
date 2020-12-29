//
//  CustomSplitViewController.swift
//  RealmInAppBrowser
//
//  Created by Matt on 06.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import Foundation
import UIKit

class CustomSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible
    }
}
