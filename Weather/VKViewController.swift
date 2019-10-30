//
//  VKViewController.swift
//  Weather
//
//  Created by admin on 04/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import SwiftKeychainWrapper


final class VKViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        loginVK()
        print(Session.instance.token)
        //logoutVK()
    }
    
    func loginVK() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6973302"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            //URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "scope", value: "friends,wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
        
    }
    
    func logoutVK() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records.filter { $0.displayName.contains("vk")}, completionHandler: { })
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        let token = params["access_token"]
        guard let tokenn = token else {return}
        Session.instance.token = tokenn
        KeychainWrapper.standard.set(token!, forKey: "token")
        loadSessionToken()
        print(tokenn)
        decisionHandler(.cancel)
    }

}
