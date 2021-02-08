//
//  FavoritesVC.swift
//  RealmInAppBrowser
//
//  Created by Matt on 08.02.21.
//

import UIKit

class FavoritesVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, StoreDelegate {
    var filterTf: UITextField?
    var tableView: UITableView?
    var favoriteStore = FavoriteStore()
    var currentQuery: String?
    var selectedFavoriteAction:((_ query: String)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.favoriteStore.update()
        self.favoriteStore.delegate = self
        // Do any additional setup after loading the view.
        setupTableView()
        setupFilter()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteStore.objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = favoriteStore.objects[indexPath.row].query
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFavoriteAction?(favoriteStore.objects[indexPath.row].query)
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.favoriteStore.remove(id: favoriteStore.objects[indexPath.row].id)
        }
    }

    func setupTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)

        self.tableView = tableView

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:60)
        ])

        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupFilter() {

        let tf = UITextField(frame: .zero)
        tf.borderStyle = .roundedRect
        tf.placeholder = "Type your NSPredicate query"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .always
        tf.smartDashesType = .no
        tf.smartQuotesType = .no
        tf.smartInsertDeleteType = .no
        tf.text = currentQuery
        self.view.addSubview(tf)
        self.filterTf = tf

        let searchBtn = UIButton(type: .custom)
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.setTitle("Add", for: .normal)
        searchBtn.backgroundColor = UIColor(red: 0.23, green: 0.29, blue: 0.48, alpha: 1.00)
        searchBtn.layer.cornerRadius = 5
        searchBtn.addTarget(self, action:#selector(pressedAdd) , for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [tf, searchBtn])
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
            searchBtn.widthAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc func pressedAdd() {
        guard let query = filterTf?.text else {
            return
        }

        self.favoriteStore.add(query: query)
        self.tableView?.reloadData()
        self.filterTf?.text = ""
    }

    func didUpdate(store: StoreProtocol, isEmpty: Bool, hasError: Bool) {
        self.tableView?.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
