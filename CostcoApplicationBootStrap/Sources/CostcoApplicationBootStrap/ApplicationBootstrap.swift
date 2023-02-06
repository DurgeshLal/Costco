//
//  ApplicationBootstrap.swift
//
//
//  Created by Durgesh Lal on 2/3/23.
//

import Foundation
import CostcoApis

public class ApplicationBootstrap {
    public static func createApplicationBootstrap() -> ServiceResolving {
        let container: ServiceResolving = Container()
        container.register(NetworkManaging.self) { _ in NetworkManager(EnumEnvironment.prod, cache: container.resolve()) }
        container.register(TemperatureFormatting.self) { _ in TemperatureFormatter() }
        container.register(Caching.self) { _ in CacheWrapper() }
        return container
    }
}
