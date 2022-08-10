//
//  Config.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import PathKit
import Json

public func Config() -> Settings? {
    let current = Path.current + Path(".overlook")

    do {
        let data = try current.read()
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let settings = try Settings(dictionary: json)

        return settings

    } catch {
        fatalError(error.localizedDescription)
    }
}
