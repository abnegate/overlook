//
//  adhoc.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import SwiftCLI
import PathKit
import Rainbow
import Tasks
import Watch

public class WatchCommand: Command {

    public let name = "watch"
    public let signature = ""
    public let shortDescription = "Watch files or directories and execute command"

    private let taskManager = TaskManager()

    @Key("-t", "--target", description: "Comma separated list of directory or files to watch")
    var targets: String?

    @Key("-i", "--ignore", description: "Comma separated list of files or directories to ignore")
    var ignore: String?

    @Key("-e", "--execute", description: "Command to execute when targets are changed.")
    var exec: String?

    @Flag("-v", "--verbose", description: "Suppress output of running tasks.")
    var verbose: Bool

    public func execute() throws {
        guard let targets = targets, let exec = exec else {
            throw CLI.Error(message: "Arguments `target` and `execute` are required")
        }

        var targetArray = targets
                .replacingOccurrences(of: ", ", with: ",")
                .components(separatedBy: ",")

        targetArray = targetArray.map {
            String(describing: (Path($0).absolute()))
        }

        let ignoreArray = ignore?
                .replacingOccurrences(of: ", ", with: ",")
                .components(separatedBy: ",") ?? []

        let execArray = exec.components(separatedBy: " ")

        taskManager.verbose = verbose

        startup(execArray.joined(separator: " "), watching: targetArray)

        taskManager.create(execArray) { [weak self] (data) in
            guard let `self` = self, let str = String(data: data, encoding: .utf8) else {
                return
            }

            if self.taskManager.verbose {
                let output = str.trimmingCharacters(in: .whitespacesAndNewlines)

                print(output)
            }
        }

        taskManager.start()

        watch(targetArray, exclude: ignoreArray) {
            self.taskManager.restart()
        }
    }
}

