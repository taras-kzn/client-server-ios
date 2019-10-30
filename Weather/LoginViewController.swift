//
//  LoginViewController.swift
//  Weather
//
//  Created by admin on 01/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseAuth


final class LoginViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var listener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateTitlesAppearing()
        animationWeather()
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
    }
    
    @IBAction func singIn(_ sender: Any) {
        guard let email = loginInput.text,
        let password = passwordInput.text,
            email.count > 0,
            password.count > 0 else {
            return
                self.showLoginError(titel: "Error", message: "Логин  пароль не введен")
        }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error,user  == nil {
                self.showLoginError(titel: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func singUp(_ sender: Any) {

        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        alert.addTextField { textEmail in
            textEmail.placeholder = "Введите адрес электронной почты"
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Введите ваш пароль"
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

            guard let emailField = alert.textFields?[0],
                let passwordField = alert.textFields?[1],
                let password = passwordField.text,
                let email = emailField.text else { return }
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                if let error = error {
                    self?.showLoginError(titel:
                        "Error", message: error.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func showLoginError(titel: String,message: String){
        let alter = UIAlertController(title: titel, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification){
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey:UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification){
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listener = Auth.auth().addStateDidChangeListener { _, user in

            if user != nil{
                self.performSegue(withIdentifier: "login", sender: self)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(listener!)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func animateTitlesAppearing(){
        let offSet = view.bounds.width
        loginLabel.transform = CGAffineTransform(translationX: -offSet, y: 0)
        passwordLabel.transform = CGAffineTransform(translationX: offSet, y: 0)
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
            self.loginLabel.transform = .identity
            self.passwordLabel.transform = .identity
        }, completion: nil)
    }
    
    func animationWeather(){
        self.weatherLabel.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height / 2)
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut , animations: {
            self.weatherLabel.transform = .identity
        })
        
    }

}
