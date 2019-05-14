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

class VKViewController: UIViewController,WKNavigationDelegate {
    
    
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
            URLQueryItem(name: "scope", value: "262150"),
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
        //Session.instance.token = token!
        KeychainWrapper.standard.set(token!, forKey: "token")
//        loadSessionToken()
        print(token)
        
//        Alamofire.request("https://api.vk.com/method/users.get?user_ids=3639061&fields=bdate,city,counters,photo_max_orig&access_token=dc0ede5e8a10f7d1c2414fbaa9c360b176b79d4f44786265d506491b9f02a7edc2da0edd262865e85351a&v=5.95").responseJSON { (response) in
//            print(response.value)
//        }
//
//        Alamofire.request("https://api.vk.com/method/friends.get?user_id=3639061&order=hints&count=3&fields=domain,photo_50&name_case=ins&access_token=\(Session.instance.token)&v=5.95").responseJSON { (response) in
//            print(response.value)
//        }
//
//        Alamofire.request("https://api.vk.com/method/groups.get?user_id=3639061&count=3&extended=1&fields=city&access_token=\(Session.instance.token)&v=5.95").responseJSON { (response) in
//            print(response.value)
//        }
        
//        Alamofire.request(url, method: .get, parameters: params).responseData { repsonse in
//            guard let data = repsonse.value else { return }
//            let weather = try! JSONDecoder().decode(FriendsResponse.self, from: data).response
//            print(weather)
//        }
        
        
        decisionHandler(.cancel)
    }

}
