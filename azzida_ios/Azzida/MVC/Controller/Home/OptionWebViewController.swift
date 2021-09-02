//
//  OptionWebViewController.swift
//  Azzida
//
//  Created by Varun Naharia on 02/02/21.
//  Copyright © 2021 Vishnu Chhipa. All rights reserved.
//

import UIKit
import WebKit

protocol OptionWebViewDelegate
{
    func addTomyProfile()
}

class OptionWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var btnAddToMyProfile: UIButton!
    @IBOutlet weak var webView: WKWebView!
   
    var delegate:OptionWebViewDelegate?
    var successChecker : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let htmlFile = Bundle.main.path(forResource: "AzzidaVerfified", ofType: "html")
        let html = try! String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        self.webView.loadHTMLString(html, baseURL: nil)
        self.webView.navigationDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        
         if successChecker == "yes"{
            btnAddToMyProfile.isHidden = true
                   let htmlFile = Bundle.main.path(forResource: "AzzidaVerfifiedThanks", ofType: "html")
                          let html = try! String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
                          self.webView.loadHTMLString(html, baseURL: nil)
                          self.webView.navigationDelegate = self
               }
    }
    override func viewWillDisappear(_ animated: Bool) {
        successChecker = ""
    }
    
    @IBAction func addToMyProfileAction(_ sender: Any) {
        self.delegate?.addTomyProfile()
        self.dismiss(animated: true, completion: nil)
    }
    
 
    @IBAction func actionCheckStatus(_ sender: Any) {
    }
   
    
    @IBAction func closeAction(_ sender: Any) {
        if successChecker == "yes"{
            if let viewController = navigationController?.viewControllers.first(where: {$0 is OptionViewController}) {
                  navigationController?.popToViewController(viewController, animated: false)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               let host = url.host,
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
    
}

