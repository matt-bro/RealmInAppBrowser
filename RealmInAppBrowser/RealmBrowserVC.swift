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
    //var objects:[DynamicObject] = []
    var store: RealmStore?
    var collectionVC: UICollectionViewController?

    var sortingBy: (name: String, asc: Bool)?

    var filterTf: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.translatesAutoresizingMaskIntoConstraints = false
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
        cvc.collectionView.translatesAutoresizingMaskIntoConstraints = false

        
        self.view.addSubview(cvc.collectionView)

        NSLayoutConstraint.activate([
            cvc.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            cvc.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            cvc.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            cvc.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:44)
        ])

        self.setupFilter()

        self.collectionVC = cvc
        store?.delegate = self
    }

    func setupFilter() {


        let tf = UITextField(frame: .zero)
        tf.placeholder = " Type your query"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        self.view.addSubview(tf)
        self.filterTf = tf


        let searchBtn = UIButton(type: .custom)
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.setTitle("Filter", for: .normal)
        searchBtn.backgroundColor = .systemTeal
        searchBtn.addTarget(self, action:#selector(pressedFilter) , for: .touchUpInside)

        let stackview = UIStackView(arrangedSubviews: [tf, searchBtn])
        stackview.axis = .horizontal
        stackview.alignment = .fill
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackview)
        NSLayoutConstraint.activate([
            stackview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackview.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            stackview.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            stackview.heightAnchor.constraint(equalToConstant: 44)
        ])

        NSLayoutConstraint.activate([
            searchBtn.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func pressedFilter() {
        self.filterTf?.resignFirstResponder()
        print("pressed filter with query \(self.filterTf?.text)")
    }
}

extension RealmBrowserVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let newText = textField.text?.appending(string)
//        if let filterTf = filterTf, (textField == self.filterTf) {
//
//        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.pressedFilter()
        return textField.resignFirstResponder()
    }
}

extension RealmBrowserVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 200, height: 10)
        }
        return CGSize(width: 200, height: 10)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension RealmBrowserVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store?.propertyCount ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.store?.objectCount ?? 0)+1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //header cell
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
            return self.configureHeaderCell(cell: cell, indexPath: indexPath)
        }
        //data cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataCell.identifier, for: indexPath) as! DataCell
        return self.configureDataCell(cell: cell, indexPath: indexPath)
    }

    func configureHeaderCell(cell: HeaderCell, indexPath: IndexPath) -> HeaderCell {
        if let property = self.store?.propertyName(index: indexPath.row) {
            cell.textLabel.text = property

            if let sortingBy = self.store?.sortingBy, sortingBy.name == property  {
                cell.ascending = sortingBy.asc
            }
        }

        //TODO: sort
        cell.indexPath = indexPath
        cell.pressedAction = { index in
            if let index = index {
                //print("sort by \(self.headers[index.row])")
                //self.pressedSort(for: self.headers[index.row])
            }
        }

        return cell
    }

    func configureDataCell(cell: DataCell, indexPath: IndexPath) -> DataCell {
        cell.textLabel.text = self.store?.value(propertyIndex: indexPath.row, objectIndex: indexPath.section-1)
        cell.backgroundColor = (indexPath.section%2 == 0) ? .systemGray6 : .white
        return cell
    }
}

extension RealmBrowserVC: StoreDelegate {
    func didUpdate(store: StoreProtocol, isEmpty: Bool, hasError: Bool) {
        self.collectionVC?.collectionView.reloadData()
    }
}

class HeaderCell: UICollectionViewCell {

    var textLabel = UILabel()
    var actionBtn: UIButton?
    var indexPath: IndexPath?
    var pressedAction: ((IndexPath?)->())?

    var ascending: Bool? {
        didSet {
            if let ascending = ascending {
                let arrow = (ascending == true) ? " \u{2191}" : " \u{2193}"
                self.textLabel.text?.append(arrow)
            }
        }
    }

    static let identifier = "HeaderCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
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
            actionBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
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
        textLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
