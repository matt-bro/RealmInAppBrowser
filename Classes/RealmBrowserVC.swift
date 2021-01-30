//
//  RealmBrowserVC.swift
//  RealmInAppBrowser
//
//  Created by Matt on 06.10.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//

import UIKit
import RealmSwift

internal class RealmBrowserVC: UIViewController {

    var headers:[String] = []
    //var objects:[DynamicObject] = []
    var store: RealmStore?
    var collectionVC: UICollectionViewController?

    var sortingBy: (name: String, asc: Bool)?

    var filterTf: UITextField?

    public override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white


        let flowLayout = NoBreakSectionCollectionViewLayout()
        //flowLayout.minimumLineSpacing = 10

        let cvc = UICollectionViewController(collectionViewLayout: flowLayout)
        cvc.collectionView?.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.identifier)
        cvc.collectionView?.register(DataCell.self, forCellWithReuseIdentifier: DataCell.identifier)
        cvc.collectionView?.delegate = self
        cvc.collectionView?.dataSource = self
        cvc.collectionView?.backgroundColor = .white
        cvc.collectionView?.translatesAutoresizingMaskIntoConstraints = false

        
        self.view.addSubview(cvc.collectionView!)

        NSLayoutConstraint.activate([
            cvc.collectionView!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            cvc.collectionView!.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            cvc.collectionView!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            cvc.collectionView!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:60)
        ])

        self.setupFilter()

        self.collectionVC = cvc
        store?.delegate = self
    }

    func setupFilter() {


        let tf = UITextField(frame: .zero)
        tf.borderStyle = .roundedRect
        tf.placeholder = " Type your query"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.smartDashesType = .no
        tf.smartQuotesType = .no
        tf.smartInsertDeleteType = .no
        self.view.addSubview(tf)
        self.filterTf = tf


        let searchBtn = UIButton(type: .custom)
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.setTitle("Filter", for: .normal)
        searchBtn.backgroundColor = UIColor(red: 0.23, green: 0.29, blue: 0.48, alpha: 1.00)
        searchBtn.layer.cornerRadius = 5
        searchBtn.addTarget(self, action:#selector(pressedFilter) , for: .touchUpInside)

        let resetBtn = UIButton(type: .custom)
        resetBtn.translatesAutoresizingMaskIntoConstraints = false
        resetBtn.setTitle("Reset", for: .normal)
        resetBtn.backgroundColor = .systemGray4
        resetBtn.layer.cornerRadius = 5
        resetBtn.addTarget(self, action:#selector(pressedResetFilter) , for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [tf, searchBtn, resetBtn])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        self.view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            searchBtn.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func pressedFilter() {
        self.filterTf?.resignFirstResponder()
        self.store?.filter(query: self.filterTf?.text ?? "")
        print("pressed filter with query \(self.filterTf?.text ?? "")")
    }

    @objc func pressedResetFilter() {
        self.filterTf?.text = ""
        self.store?.resetFilter()
    }
}

extension RealmBrowserVC: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {

    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let newText = textField.text?.appending(string)
//        if let filterTf = filterTf, (textField == self.filterTf) {
//
//        }
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.pressedFilter()
        return textField.resignFirstResponder()
    }
}

extension RealmBrowserVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 200, height: 10)
        }
        return CGSize(width: 200, height: 10)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension RealmBrowserVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store?.propertyCount ?? 0
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.store?.objectCount ?? 0)+1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
            cell.typeLabel.text = self.store?.propertyType(index: indexPath.row)

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
                if let property: Property = self.store?.get(index: index.row) {
                    self.store?.sort(for: property.name)
                }
            }
        }

        return cell
    }

    func configureDataCell(cell: DataCell, indexPath: IndexPath) -> DataCell {
        cell.textLabel.text = self.store?.value(propertyIndex: indexPath.row, objectIndex: indexPath.section-1)
        cell.backgroundColor = (indexPath.section%2 == 0) ? .systemGray6 : .white
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(onLongPressCell(gesture:))))
        cell.indexPath = indexPath
        return cell
    }

    @objc func onLongPressCell(gesture:UIGestureRecognizer) {
        guard let cell = gesture.view as? DataCell else {
            return
        }

        if gesture.state == .ended {
            print("did long press")


            let alertController = UIAlertController(title: "Select Photo", message: "value", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "Copy value", style: .default) { (action) in
                UIPasteboard.general.string = cell.textLabel.text
            }
            let action2 = UIAlertAction(title: "View value", style: .default) { (action) in
                self.present(CellValueVC.instantiateWithNavigationAndClose(valueText: cell.textLabel.text), animated: true, completion: nil)
            }

            let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            alertController.addAction(action1)
            alertController.addAction(action2)
            alertController.addAction(action3)

            if let presenter = alertController.popoverPresentationController {
                presenter.sourceView = cell;
                presenter.sourceRect = cell.bounds;
            }
            self.present(alertController, animated: true, completion: nil)

        }
    }
}

extension RealmBrowserVC: StoreDelegate {
    func didUpdate(store: StoreProtocol, isEmpty: Bool, hasError: Bool) {
        self.collectionVC?.collectionView?.reloadData()
    }
}

internal class HeaderCell: UICollectionViewCell {

    var textLabel = UILabel()
    var typeLabel = UILabel()
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


        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = UIFont.systemFont(ofSize: 9)
        typeLabel.textColor = UIColor(red: 0.23, green: 0.29, blue: 0.48, alpha: 1.00)
        typeLabel.text = "type"
        contentView.addSubview(typeLabel)

        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15)
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

internal class DataCell: UICollectionViewCell {
    var textLabel = UILabel()
    static let identifier = "DataCell"
    var indexPath: IndexPath?

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

internal class CellValueVC: UIViewController {

    var textView: UITextView?
    var valueText: String? {
        didSet {
            self.textView?.text = valueText
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.textView?.text = valueText
    }

    func setup() {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        ])

        self.textView = textView


        let closeBtn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(pressedClose))
        self.navigationItem.leftBarButtonItem = closeBtn
    }

    @objc func pressedClose() {
        self.dismiss(animated: true, completion: nil)
    }

    static func instantiateWithNavigationAndClose(valueText: String? = nil) -> UINavigationController {
        let vc = CellValueVC()
        vc.valueText = valueText
        let nvc = UINavigationController(rootViewController: vc)
        return nvc
    }
}
