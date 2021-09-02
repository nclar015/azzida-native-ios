//
//  WebViewController.swift
//  Azzida
//
//  Created by Varun Naharia on 28/09/20.
//  Copyright © 2020 Vishnu Chhipa. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate {
    func getAccount(code:String)
}

class WebViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    var delegate:WebViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        live web url
//        webView.load(URLRequest(url: URL(string: "https://dashboard.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_HxAz1sDRY3JaN5rbE2r0lfoBtiFTOp5m&scope=read_write")!))
//
        //test url
        webView.load(URLRequest(url: URL(string: "https://dashboard.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_HxAzYfQjaS2BwXRmSm59rbmP7rMERhEV&scope=read_write")!))
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
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

extension WebViewController:WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let url:URL = webView.url!
        if(url.query!.contains("code="))
        {
            let code = url.query?.components(separatedBy: "code=")[1]
            print(code!)
            self.delegate?.getAccount(code: code!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}
