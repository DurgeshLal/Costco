//
//  MountainPassRoadViewModel.swift
//  
//
//  Created by Durgesh Lal on 2/5/23.
//

import Foundation
import CostcoApis

struct MountainPassRoadViewModel {
    private let data: MountainPass
    private let temperatureFormatter: TemperatureFormatting
    
    init(data: MountainPass, temperatureFormatter: TemperatureFormatting) {
        self.data = data
        self.temperatureFormatter = temperatureFormatter
    }
    
    var roadCondition: String? {
        data.roadCondition
    }
    
    var temprature: String? {
        temperatureFormatter.formatFahrenheit(temperature: data.temperatureInFahrenheit)
    }
    
    var weatherCondition: String? {
        data.weatherCondition
    }
    
    var screenTitle: String? {
        data.mountainPassName
    }
}
