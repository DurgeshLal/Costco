//
//  TemperatureFormatter.swift
//  
//
//  Created by Durgesh Lal on 2/6/23.
//

import Foundation
import CostcoApis

struct TemperatureFormatter: TemperatureFormatting {
    
    func formatFahrenheit(temperature: Int?) -> String? {
        guard let temperature = temperature else { return nil }
        return "\(temperature)°F"
    }
}
