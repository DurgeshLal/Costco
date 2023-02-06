//
//  CacheWrapper.swift
//  
//
//  Created by Durgesh Lal on 2/6/23.
//

import Foundation
import CostcoApis

class CacheWrapper: Caching {
    
    private let cache = NSCache<AnyObject, AnyObject>()
    
    var enable: Bool { true }
    
    func object(forKey key: AnyObject) -> AnyObject? {
        return cache.object(forKey: key)
    }
    
    func setObject(_ obj: AnyObject, forKey key: AnyObject) {
        cache.setObject(obj, forKey: key)
    }
}
