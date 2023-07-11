//
//  HostSelectionController.swift
//  DeveloperToolManager
//
//  Created by &&TairoV on 24.05.2023.
//

import UIKit

public class ServerSelectionViewController: UIViewController {

    private let hostKeys: [String]
    private let userDefaultsKey: String
    private let selectedServer = UILabel()

    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = UINavigationBar.appearance().tintColor
        return button
    }()

    public override func viewDidLoad() {

        view.backgroundColor = .white
        configureHost()
        setupUI()
        addActions()
    }

    public init(hostKeys: [String], userDefaultsKey: String) {
        self.hostKeys = hostKeys
        self.userDefaultsKey = userDefaultsKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHost() {
        if UserDefaults.standard.object(forKey: userDefaultsKey) == nil {
            UserDefaults.standard.set(hostKeys.first, forKey: userDefaultsKey)
        }
       selectedServer.text = "Тeкущий хост: " + (UserDefaults.standard.string(forKey: userDefaultsKey) ?? "")
    }
    
    private func setupUI() {
        view.addSubview(pickerView)
        view.addSubview(selectedServer)
        view.addSubview(saveButton)

        var layoutConstraints = [NSLayoutConstraint]()

        selectedServer.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            selectedServer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedServer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectedServer.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -32)
        ]

        pickerView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ]

        NSLayoutConstraint.activate(layoutConstraints)

    }

    private func addActions() {
        saveButton.addTarget(self, action: #selector(saveStend), for: .touchUpInside)
    }

    @objc private func saveStend() {
        let alert = UIAlertController(
            title: "Осторожно Стенд 😱",
            message: "Вы точно хотите изменить стенд? После этого приложение перезагружается! 🤡",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK 🤬",
            style: .default,
            handler: { [unowned self] _ in
                let selectedRow = self.pickerView.selectedRow(inComponent: 0)
                UserDefaults.standard.set(self.hostKeys[selectedRow], forKey: self.userDefaultsKey)
                
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    exit(0)
                }
            })
        let cancelAction = UIAlertAction(title: "Отмена 🥹", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension ServerSelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hostKeys.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hostKeys[row]
    }
}

