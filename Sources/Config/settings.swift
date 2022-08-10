//
//  settings.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import PathKit
import Json

public struct Settings {
    public var verbose: Bool = true
    public var envVars: [String: String] = [:]
    public var ignore: [String] = []
    public var directories: [String] = []
    public var execute: String = ""

    public var paths: [Path] {
        directories.map {
            Path($0).absolute()
        }
    }
}

extension Settings {
    public init(dictionary: [String: Any]) throws {
        do {
            envVars = try decode(dictionary, key: "Env")
            verbose = try decode(dictionary, key: "verbose")
            ignore = try decode(dictionary, key: "ignore")
        } catch {
            print(error.localizedDescription)
        }

        directories = try decode(dictionary, key: "directories")
        execute = try decode(dictionary, key: "execute")
    }
}

