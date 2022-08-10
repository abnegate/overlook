//
//  overlook.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import PathKit
import Rainbow
import SwiftCLI
import Config
import Env

public class Overlook {

    static let name = "overlook"
    static let version = "0.2.0"
    static let desc = "File monitoring tool that executes on change. Used anywhere."

    static let dotTemplate: [String: Any] = [
        "env": ["example": "variable"],
        "verbose": true,
        "ignore": [".git", ".gitignore", ".overlook",],
        "directories": ["build", "tests",],
        "execute": "ls -la",
    ]

    public func run() {
        let cli = CLI(
            name: Overlook.name,
            version: Overlook.version,
            description: Overlook.desc,
            commands: [
                InitCommand(),
                DefaultCommand(),
                WatchCommand()
            ]
        )

        cli.aliases["-h"] = "help"
        cli.aliases["--help"] = "help"

        cli.aliases["-v"] = "version"
        cli.aliases["--version"] = "version"

        cli.aliases["-i"] = "init"
        cli.aliases["--init"] = "init"

        cli.aliases["-w"] = "watch"
        cli.aliases["--watch"] = "watch"

        let result = cli.go()

        guard result == 0 else {
            exit(result)
        }
//        guard runOnce.contains(where: { $0.name == router.current }) else {
            dispatchMain()
//        }
        exit(result)
    }
}

public func startup(_ run: String, watching: [String]) {
    let executing = "executing: "
    let target = run.bold

    print("\nStarting overlook...".green.bold)
    print(executing + target.bold)
    print("Watching:")

    for directory in watching {
        print("  ", directory.bold)
    }
}





