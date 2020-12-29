//
//  RealmBrowserVC.swift
//  RealmInAppBrowser
//
//  Created by Matt on 06.10.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import UIKit
import RealmSwift

class RealmBrowserVC: UIViewController {

    var headers:[String] = []
    var objects:[DynamicObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white

        let flowLayout = NoBreakSectionCollectionViewLayout()
        //flowLayout.minimumLineSpacing = 10

        let cvc = UICollectionViewController(collectionViewLayout: flowLayout)
        cvc.collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.identifier)
        cvc.collectionView.register(DataCell.self, forCellWithReuseIdentifier: DataCell.identifier)
        cvc.collectionView.delegate = self
        cvc.collectionView.dataSource = self
        cvc.collectionView.backgroundColor = .white
        
        self.view.addSubview(cvc.collectionView)

        NSLayoutConstraint.activate([
            cvc.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            cvc.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            cvc.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            cvc.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        ])

    }
}

extension RealmBrowserVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 200, height: 20)
        }
        return CGSize(width: 200, height: 20)
    }
}

extension RealmBrowserVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.headers.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.objects.count+1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
            cell.textLabel.text = headers[indexPath.row]
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCell.identifier, for: indexPath) as! DataCell
        let object = self.objects[indexPath.section-1]
        let propertyName = self.headers[indexPath.row]

        cell.textLabel.text = object.value(forUndefinedKey: propertyName) as? String ?? ""
        //print("\(indexPath.section) - \(indexPath.row)")
        return cell
    }


}

class HeaderCell: UICollectionViewCell {

    var textLabel = UILabel()
    static let identifier = "HeaderCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        ])

        self.backgroundColor = .systemGray3
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DataCell: UICollectionViewCell {
    var textLabel = UILabel()
    static let identifier = "DataCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 20)
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
