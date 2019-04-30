//
//  LoginViewController.swift
//  Weather
//
//  Created by admin on 01/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInLabel: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateAuthButton()
        animateTitlesAppearing()
        animationWeather()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        scrollView?.addGestureRecognizer(hideKeyboardGesture)

        
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        
        let login = loginInput.text!
        let password = passwordInput.text!
        
        if login == "a" && password == "1" {
            print("успешная авторизация")
        } else {
            print("неуспешная авторизация")
        }

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        let checkResult = checkUserData()
        if !checkResult {
            showLoginError()
        }
        return checkResult
    }
    
    func checkUserData() -> Bool{
        let login = loginInput.text!
        let password = passwordInput.text!
        
        if login == "a" && password == "1" {
            return true
        } else {
            return false
        }

    }
    
    func showLoginError(){
        let alter = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
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
    func animateAuthButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.signInLabel.layer.add(animation, forKey: nil)
    }
    
    
    
    

}
