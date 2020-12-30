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
    var collectionVC: UICollectionViewController?

    var sortingBy: (name: String, asc: Bool)?

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

        self.collectionVC = cvc

    }
}

extension RealmBrowserVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 200, height: 15)
        }
        return CGSize(width: 200, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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
            let property = headers[indexPath.row]
            cell.textLabel.text = property
            cell.indexPath = indexPath
            cell.pressedAction = { index in
                if let index = index {
                    print("sort by \(self.headers[index.row])")
                    self.pressedSort(for: self.headers[index.row])
                }
            }

            if let sortingBy = self.sortingBy {
                if sortingBy.name == property {
                    let arrow = sortingBy.asc == true ? " \u{2191}" : " \u{2193}"
                    cell.textLabel.text?.append(arrow)
                }
            }

            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCell.identifier, for: indexPath) as! DataCell
        let object = self.objects[indexPath.section-1]
        let propertyName = self.headers[indexPath.row]

        cell.textLabel.text = object.value(forUndefinedKey: propertyName) as? String ?? ""
        //print("\(indexPath.section) - \(indexPath.row)")
        return cell
    }

    func configureHeaderCell() {}
    func configureDataCell() {}

    //TODO: sort need to consider the type in the future
    func pressedSort(for propertyName: String) {
        if objects.isEmpty { return }

        var ascending = false

        if let sortingBy = sortingBy {
            if sortingBy.name == propertyName {
                ascending = !sortingBy.asc
                self.sortingBy = (propertyName, ascending)
            } else {
                self.sortingBy = (propertyName, ascending)
            }
        } else {
            self.sortingBy = (propertyName, ascending)
        }
        //check if property exists
        self.objects.sort(by: {
            if let val1 = $0.value(forUndefinedKey: propertyName) as? String, let val2 = $1.value(forUndefinedKey: propertyName) as? String {
                if ascending { return val1 < val2 } else { return val1 > val2 }
            }
            return true
        })

        self.collectionVC?.collectionView.reloadData()
    }
}

class HeaderCell: UICollectionViewCell {

    var textLabel = UILabel()
    var actionBtn: UIButton?
    var indexPath: IndexPath?
    var pressedAction: ((IndexPath?)->())?
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

        self.backgroundColor = .systemGray4

        let actionBtn = UIButton(type: .custom)
        actionBtn.translatesAutoresizingMaskIntoConstraints = false
        actionBtn.addTarget(self, action: #selector(pressedActionBtn), for: .touchUpInside)
        contentView.addSubview(actionBtn)

        NSLayoutConstraint.activate([
            actionBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            actionBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            actionBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
            actionBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        ])
        
        self.actionBtn = actionBtn
    }

    @objc func pressedActionBtn() {
        self.pressedAction?(self.indexPath)
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
