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
        container.register(NetworkManaging.self) { _ in NetworkManager(EnumEnvironment.prod) }
        return container
    }
}
