//
//  ErrorView.swift
//  RealmInAppBrowser
//
//  Created by Matt on 26.01.21.
//

import UIKit


internal class ErrorView: UIView {
    var errorTextLabel: UILabel?
    var pressedBtnAction:(()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.backgroundColor = .red
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false
        setupErrorLabel()
        setupActionBtn()
    }

    func setupErrorLabel() {
        let errorTextLabel = UILabel(frame: .zero)
        errorTextLabel.text = "This is a test error"
        errorTextLabel.textColor = .black
        errorTextLabel.translatesAutoresizingMaskIntoConstraints = false
        errorTextLabel.numberOfLines = 2
        self.addSubview(errorTextLabel)


        NSLayoutConstraint.activate([
            errorTextLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            errorTextLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant:0),
            errorTextLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -65),
            errorTextLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant:0)
        ])
        self.errorTextLabel = errorTextLabel
    }

    func setupActionBtn() {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor(white: 0.1, alpha: 0.2)
        btn.layer.cornerRadius = 5
        btn.setTitle("Close", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(pressedAction), for: .touchUpInside)
        self.addSubview(btn)

        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 50),
            btn.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant:-5),
            btn.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            btn.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant:5)
        ])
    }

    @objc func pressedAction() {
        guard let pressedBtnAction = pressedBtnAction else {
            self.hide()
            return
        }
        pressedBtnAction()
    }

    func show(errorMessage: String) {
        self.isHidden = false
        self.alpha = 1.0
        self.errorTextLabel?.text = errorMessage
    }

    func hide() {
        self.isHidden = true
        self.errorTextLabel?.text = ""
    }
}
