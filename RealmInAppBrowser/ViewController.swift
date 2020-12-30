//
//  ViewController.swift
//  RealmInAppBrowser
//
//  Created by Matt on 30.12.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func pressedOpen(_ sender: Any) {

        let spvc = CustomSplitViewController()
        spvc.modalPresentationStyle = .fullScreen
        self.present(spvc, animated: true, completion: nil)
    }

}
