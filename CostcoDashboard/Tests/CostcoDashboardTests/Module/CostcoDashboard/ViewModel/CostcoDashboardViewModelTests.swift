//
//  CostcoDashboardViewModelTests.swift
//  
//
//  Created by Durgesh Lal on 2/6/23.
//

import XCTest
@testable import CostcoDashboard

class CostcoDashboardViewModelTests: XCTestCase {
    
    var viewModel: CostcoDashboardViewModel!
    
    override func setUp() async throws {
        let dataManager = MockCostcoDashboardDataManager(MockNetworkManager())
        viewModel = CostcoDashboardViewModel(dataManager: dataManager, coordinator: nil)
    }
    
    override func tearDown() async throws {
        viewModel = nil
    }
    
    
    func testTitle() {
        XCTAssertEqual(viewModel.title, "Costco")
    }
    
    func testHomePageUrl() {
        XCTAssertEqual(viewModel.homePageUrl.absoluteString, "https://www.costco.com/")
    }
    
    func testScript() {
        XCTAssertEqual(viewModel.script, """
        var buttons = document.getElementsByClassName("MuiButtonBase-root MuiButton-root MuiButton-text-button MuiButton-text-buttonPrimary MuiButton-sizeMedium MuiButton-text-buttonSizeMedium MuiButton-root MuiButton-text-button MuiButton-text-buttonPrimary MuiButton-sizeMedium MuiButton-text-buttonSizeMedium css-4bcnsk");
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].addEventListener("click", function() {
            webkit.messageHandlers.buttonClicked.postMessage("Button was clicked");
            });
        }
        """)
    }
    
    func testApiCall() {
        Task {
            do {
                _ = try await viewModel.fetchRoadCondition()
            } catch {
                
            }
        }
    }
}
