//
//  DetailViewController.swift
//  RealmInAppBrowser
//
//  Created by Matt on 06.10.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let rb = RealmBrowserVC()
        //rb.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(rb, animated: false)
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

