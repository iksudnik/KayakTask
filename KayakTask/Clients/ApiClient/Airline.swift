//
//  Airline.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import Foundation

struct Airline: Codable {
    
    enum Alliance: String, Codable {
        case ow = "OW"
        case sa = "SA"
        case st = "ST"
    }
    
    let site: String
    let code: String
    let alliance: Alliance?
    let phone: String
    let name: String
    let usName: String
    let defaultName: String
    let logoURL: String
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        site = try container.decode(String.self, forKey: .site)
        code = try container.decode(String.self, forKey: .code)
        phone = try container.decode(String.self, forKey: .phone)
        name = try container.decode(String.self, forKey: .name)
        usName = try container.decode(String.self, forKey: .usName)
        defaultName = try container.decode(String.self, forKey: .defaultName)
        logoURL = try container.decode(String.self, forKey: .logoURL)
        
        let rawAlliance = try? container.decode(String.self, forKey: .alliance)
        if let rawAlliance {
            alliance = Alliance(rawValue: rawAlliance)
        } else {
            alliance = nil
        }
    }
    
    init(site: String,
         code: String,
         alliance: Airline.Alliance? = nil,
         phone: String,
         name: String,
         usName: String,
         defaultName: String,
         logoURL: String) {
        self.site = site
        self.code = code
        self.alliance = alliance
        self.phone = phone
        self.name = name
        self.usName = usName
        self.defaultName = defaultName
        self.logoURL = logoURL
    }
    
}


extension Airline: Identifiable {
    var id: String {
        return code
    }
}

extension Airline {
    var fixedLogoUrl: URL? {
        URL(string: AppLinks.contentBase + logoURL)
    }
}


// MARK: - Mock

extension Airline {
    static let mock1 = Self(site: "https://sites.miticket.mx/timsinaloa/#tim_home",
                           code: "TIMPREMIER",
                           alliance: nil,
                           phone: "",
                           name: "Tim Premier",
                           usName: "Tim Premier",
                           defaultName: "Tim Premier",
                           logoURL: "/rimg/provider-logos/airlines/v/TIMPREMIER.png?crop=false&width=108&height=92&fallback=default3.png&_v=5fdeeefe9087127fbfeacce6a5e285cf")
    
    static let mock2 = Self(site: "https://global.shenzhenair.com/zhair/ibe/common/flightSearch.do?language=en&market=CN",
                           code: "ZH",
                            alliance: .sa,
                           phone: "+86 755 8881 4023",
                           name: "Shenzhen Airlines",
                           usName: "Shenzhen Airlines",
                           defaultName: "Shenzhen Airlines",
                           logoURL: "/rimg/provider-logos/airlines/v/ZH.png?crop=false&width=108&height=92&fallback=default1.png&_v=a32b836ccc5283b5c4e07133d47c103b")
}
