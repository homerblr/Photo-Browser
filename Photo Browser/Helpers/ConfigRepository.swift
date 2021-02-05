//
//  ConfigRepository.swift
//  Photo Browser
//
//  Created by Mikhail Kisly on 25.01.21.
//

import Foundation

class ConfigRepository {
    
    enum API {
        static var apiKey: String? {
            Bundle.main.infoDictionary?["API_KEY"] as? String
        }
        static var host: String? {
            Bundle.main.infoDictionary?["HOST"] as? String
        }
        static var path: String? {
            Bundle.main.infoDictionary?["PATH"] as? String
        }
    }
    static func getAPIKey() -> String? {
        return ConfigRepository.API.apiKey
    }
    static func getHost() -> String? {
        return ConfigRepository.API.host
    }
    static func getPath() -> String? {
        return ConfigRepository.API.path
    }
}
