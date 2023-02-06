//
//  MountainPassRoadViewController.swift
//  
//
//  Created by Durgesh Lal on 2/5/23.
//

import UIKit

class MountainPassRoadViewController: UIViewController {

    private let viewModel: MountainPassRoadViewModel
    
    @IBOutlet weak var roadConditionLabel: UILabel!
    @IBOutlet weak var temepratureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    init?(_ viewModel: MountainPassRoadViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable, renamed: "init(viewModel:coder:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this class")
    }
    
    
    private func updateUI() {
        title = viewModel.screenTitle
        roadConditionLabel.text = viewModel.roadCondition
        temepratureLabel.text = viewModel.temprature
        weatherConditionLabel.text = viewModel.weatherCondition
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
}
