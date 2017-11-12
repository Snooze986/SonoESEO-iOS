//
//  WebViewController.swift
//  Sono ESEO
//
//  Created by Sonasi KATOA on 28/05/2017.
//  Copyright © 2017 Sonasi KATOA. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see http://www.gnu.org/licenses/

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // When the user click on public. We load the Sonoeseo.com website.
        let request = URLRequest(url: URL(string: APIConstants.SONO_ROOT)!)
        webView.loadRequest(request)
    }
    
    /*
     * This function verify if the user still navigate on the sonoeseo.com website.
     * We prevent him to navigate to other website.
     */
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            if (request.url!.host! == "www.sonoeseo.com"){
                return true
            } else {
                UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
                return false
            }
        }
        return true
    }
}
