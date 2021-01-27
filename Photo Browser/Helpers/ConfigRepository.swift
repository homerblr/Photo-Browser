//
//  ConfigRepository.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 25.01.21.
//

import Foundation

class ConfigRepository {
    
    static func getAPIKey() -> String? {
        return Bundle.main.infoDictionary?["API_KEY"] as? String
    }
    static func getHost() -> String? {
        return Bundle.main.infoDictionary?["HOST"] as? String
    }
    static func getPath() -> String? {
        return Bundle.main.infoDictionary?["PATH"] as? String
    }
}
