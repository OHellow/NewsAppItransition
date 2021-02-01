//
//  SettingsVC.swift
//  NewsApp
//
//  Created by Satsishur on 01.02.2021.
//

import UIKit

class SettingsVC: UIViewController {
    //MARK: Views
    let switchOfUsingPassword: UISwitch = {
        let _switch = UISwitch()
        _switch.translatesAutoresizingMaskIntoConstraints = false
        let isUsingPassword = UserDefaults.standard.bool(forKey: "usePassword")
        if (isUsingPassword) == true {
            _switch.isOn = true
        } else {
            _switch.isOn = false
        }
        return _switch
    }()
    
    let switchView = UIView()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        return button
    }()
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: Selectors
    @objc func switchUseOfPassword() {
        let isOn = switchOfUsingPassword.isOn
        if isOn {
            UserDefaults.standard.set(true, forKey: "usePassword")
        } else {
            UserDefaults.standard.set(false, forKey: "usePassword")
        }
    }
    
    @objc func changePassword() {
        Alerts.showChangePasswordAlert(viewController: self, titleMessage: "Password change", message: "Enter new password")
    }
}

extension SettingsVC {
    func setupView() {
        setupSubviews()
        setupSwitchView()
        setupButton()
    }
    
    func setupSubviews() {
        view.addSubview(switchView)
        view.addSubview(button)
    }
    
    func setupSwitchView() {
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        switchView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        switchView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let text = UILabel()
        switchView.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Use Password"
        text.font = UIFont.systemFont(ofSize: 18)
        text.centerYAnchor.constraint(equalTo: switchView.centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: switchView.leftAnchor, constant: 5).isActive = true
        
        switchView.addSubview(switchOfUsingPassword)
        switchOfUsingPassword.rightAnchor.constraint(equalTo: switchView.rightAnchor, constant: -5).isActive = true
        switchOfUsingPassword.centerYAnchor.constraint(equalTo: switchView.centerYAnchor).isActive = true
        switchOfUsingPassword.addTarget(self, action: #selector(switchUseOfPassword), for: UIControl.Event.valueChanged)
    }
    
    func setupButton() {
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.topAnchor.constraint(equalTo: switchView.bottomAnchor, constant: 10).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
    }
}
