//
//  CostcoDashboardViewController.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import UIKit
import WebKit

class CostcoDashboardViewController: UIViewController, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "buttonClicked" {
            // Perform action to launch native page here
            print("I m here")
        }
    }
    
    
    private var viewModel: CostcoDashboardViewModel
    
    init?(_ viewModel: CostcoDashboardViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    var webView: WKWebView!
    
    private func loadHome() {
        webView.load(URLRequest(url: viewModel.homePageUrl))
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            let script = """
                var buttons = document.getElementsByClassName("MuiButtonBase-root MuiButton-root MuiButton-text-button MuiButton-text-buttonPrimary MuiButton-sizeMedium MuiButton-text-buttonSizeMedium MuiButton-root MuiButton-text-button MuiButton-text-buttonPrimary MuiButton-sizeMedium MuiButton-text-buttonSizeMedium css-4bcnsk");
                for (var i = 0; i < buttons.length; i++) {
                    buttons[i].addEventListener("click", function() {
                    webkit.messageHandlers.buttonClicked.postMessage("Button was clicked");
                    });
                }
                """
            self?.webView.evaluateJavaScript(script) { (result, error) in
                if error != nil {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "buttonClicked")
        webConfiguration.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        loadHome()
    }
}

