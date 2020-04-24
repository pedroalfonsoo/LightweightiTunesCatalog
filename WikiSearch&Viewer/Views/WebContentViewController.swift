//
//  WebContentViewController.swift
//  WikiSearch&Viewer
//
//  Created by Pedro Alfonso on 4/20/20.
//  Copyright © 2020 Pedro Alfonso. All rights reserved.
//

import UIKit
import WebKit

protocol WebContentViewControllerDismissing: class {
    func dismissViewController()
}

class WebContentViewController: UIViewController {
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SignPainter", size: 50.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.text = "Wiki Search & Viewer"
        label.translatesAutoresizingMaskIntoConstraints = false
           
        return label
    }()
    
    private let urlToLoad: String
    weak var delegate: WebContentViewControllerDismissing?
    
    init(urlToLoad: String) {
        self.urlToLoad = urlToLoad
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadWebContent()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        setupWebView()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func loadWebContent() {
        guard let webContentURL = URL(string: urlToLoad) else {
            print("Unable to create the URL object.")
            
            webView.addSubview(titleLabel)
            
            titleLabel.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
            titleLabel.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
            
            return
        }
            
        showActivityIndicatory(style: .large, color: .black)
        webView.load(URLRequest(url: webContentURL))
    }
}


// MARK: - WKWebView Delegates

extension WebContentViewController: WKNavigationDelegate {
    private func showMessage(_ withError: Error) {
        stopActivityIndicatory()
        
        showPopupAlert(title: "Browser Error", message: withError.localizedDescription) { (UIAlertAction) in
            self.delegate?.dismissViewController()
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.fadeIn(duration: 0.5)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivityIndicatory()
        titleLabel.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        showMessage(withError)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showMessage(error)
    }
}
