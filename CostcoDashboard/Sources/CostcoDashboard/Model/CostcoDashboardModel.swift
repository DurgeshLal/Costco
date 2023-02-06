//
//  File.swift
//  
//
//  Created by Durgesh Lal on 2/5/23.
//

import Foundation

struct CostcoDashboard: Codable {
    var passes: [MountainPass]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let array: [MountainPass] = try container.decode([MountainPass].self)
        passes = array
    }
}

struct MountainPass: Codable {
    let dateUpdated: String
    let elevationInFeet: Double
    let latitude: Double
    let longitude: Double
    let mountainPassId: Double
    let mountainPassName: String
    let restrictionOne: Restriction
    let restrictionTwo: Restriction
    let roadCondition: String
    let temperatureInFahrenheit: Int?
    let weatherCondition: String

    enum CodingKeys: String, CodingKey {
        case dateUpdated = "DateUpdated"
        case elevationInFeet = "ElevationInFeet"
        case latitude =  "Latitude"
        case longitude =  "Longitude"
        case mountainPassId =  "MountainPassId"
        case mountainPassName =  "MountainPassName"
        case restrictionOne =  "RestrictionOne"
        case restrictionTwo =  "RestrictionTwo"
        case roadCondition =  "RoadCondition"
        case temperatureInFahrenheit =  "TemperatureInFahrenheit"
        case weatherCondition =  "WeatherCondition"
    }
    
    struct Restriction: Codable {
        let restrictionText: String
        let travelDirection: String

        enum CodingKeys: String, CodingKey {
            case restrictionText = "RestrictionText"
            case travelDirection = "TravelDirection"
        }
    }
}

