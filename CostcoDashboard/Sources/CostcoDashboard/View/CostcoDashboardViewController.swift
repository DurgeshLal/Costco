//
//  CostcoDashboardViewController.swift
//  
//
//  Created by Durgesh Lal on 2/3/23.
//

import UIKit
import WebKit
import Combine

class CostcoDashboardViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
   
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .red
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.center = view.center
        view.addSubview(indicator)
        return indicator
    }()
    
    private var viewModel: CostcoDashboardViewModel
    
    private var cancellables: Set = Set<AnyCancellable>()
    
    required init(_ viewModel: CostcoDashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var webView: WKWebView!
    
    private func loadHome() {
        webView.load(URLRequest(url: viewModel.homePageUrl))
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "buttonClicked")
        webConfiguration.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }

    
    private func addObservers() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state  in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.activityIndicator.startAnimating()
                case .ready:
                    self.activityIndicator.stopAnimating()
                case .error(let message):
                    print("Error with \(message)")
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.backgroundColor = .white
        loadHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.reload()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(self.activityIndicator)
        addObservers()
    }
}

extension CostcoDashboardViewController {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "buttonClicked" {
            webView.stopLoading()
            // Perform action to launch native page here
            Task {
                do {
                    try await viewModel.fetchRoadCondition()
                    viewModel.didSelectWarehouses()
                } catch(let error) {
                    print("Error is \(error)")
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if viewModel.shouldCallAccountPage(navigationAction.request.url?.lastPathComponent) {
            decisionHandler(WKNavigationActionPolicy.cancel)
            Task {
                do {
                    try await viewModel.fetchRoadCondition()
                    viewModel.didSelectAccount()
                } catch(let error) {
                    print("Error is \(error)")
                }
            }
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
}

extension CostcoDashboardViewController {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.viewState = CostcoDashboardViewModel.State.ready
        evaluateJavaScript()
    }
    
    private func evaluateJavaScript() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.webView.evaluateJavaScript(self.viewModel.script) { (result, error) in
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
            }
        }
    }
}
