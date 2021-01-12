//
//  ViewController.swift
//  RealmInAppBrowser
//
//  Created by matt-bro on 01/05/2021.
//  Copyright (c) 2021 matt-bro. All rights reserved.
//

import UIKit
import RealmInAppBrowser

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    @IBAction func pressedOpen(_ sender: Any) {
        let riab = RealmInAppBrowser()
        riab.modalPresentationStyle = .fullScreen
        self.present(riab, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

