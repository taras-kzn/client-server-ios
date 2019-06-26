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
        Session.instance.token = token!
        KeychainWrapper.standard.set(token!, forKey: "token")
        loadSessionToken()
        print(token)
        
//        Alamofire.request("https://api.vk.com/method/wall.get?owner_id=3639061&count=20&filter=all&access_token=822a73b209319515335e9eb18faab29a3f08d014edc2c9a33b5eac768bd037b6daabb54967b90374701c9&v=5.95").responseJSON { (response) in
//            print(response.value)
//        }
//
//        Alamofire.request("https://api.vk.com/method/newsfeed.get?filters=post&count=1&access_token=38f22a99402302aff6555b40781c1737d49e0ff75379e65fb5d20e6b37daea2bdb55d804bf573845b8a39&v=5.95").responseJSON { (response) in
//            print(response.value)
//        }
//
//        Alamofire.request("https://api.vk.com/method/groups.get?user_id=3639061&count=3&extended=1&fields=city&access_token=71573db4d5b39a19f92389f23fbe35fdfdca909c4bd0f29b2329c14599d4edddcc24b4c84226f053459d9&v=5.95").responseJSON { (response) in
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
