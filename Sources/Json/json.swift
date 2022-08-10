//
//  JSON.swift
//  JSON
//
//  Created by Sam Soffes on 9/22/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import Foundation

/// Protocol for things that can be deserialized with JSON.
public protocol JSONDeserializable {
    /// Initialize with a JSON representation
    ///
    /// - parameter jsonRepresentation: JSON representation
    /// - throws: JSONError
    init(jsonRepresentation: [String: Any]) throws
}


public protocol JSONSerializable {
    /// JSON representation
    var jsonRepresentation: [String: Any] { get }
}


/// Errors for deserializing JSON representations
public enum JSONDeserializationError: Error {
    /// A required attribute was missing
    case missingAttribute(key: String)

    /// An invalid type for an attribute was found
    case invalidAttributeType(key: String, expectedType: Any.Type, receivedValue: Any)

    /// An attribute was invalid
    case invalidAttribute(key: String)
}


/// Generically decode an value from a given JSON dictionary.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter key: key in the dictionary
/// - returns: The expected value
/// - throws: JSONDeserializationError
public func decode<T>(_ dictionary: [String: Any], key: String) throws -> T {
    guard let value = dictionary[key] else {
        throw JSONDeserializationError.missingAttribute(key: key)
    }

    guard let attribute = value as? T else {
        throw JSONDeserializationError.invalidAttributeType(key: key, expectedType: T.self, receivedValue: value)
    }

    return attribute
}


/// Decode a date value from a given JSON dictionary. ISO8601 or Unix timestamps are supported.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter key: key in the dictionary
/// - returns: The expected value
/// - throws: JSONDeserializationError
public func decode(_ dictionary: [String: Any], key: String) throws -> Date {
    guard let value = dictionary[key] else {
        throw JSONDeserializationError.missingAttribute(key: key)
    }

    if let string = value as? String {
        guard let date = ISO8601DateFormatter().date(from: string) else {
            throw JSONDeserializationError.invalidAttribute(key: key)
        }

        return date
    }

    if let timeInterval = value as? TimeInterval {
        return Date(timeIntervalSince1970: timeInterval)
    }

    if let timeInterval = value as? Int {
        return Date(timeIntervalSince1970: TimeInterval(timeInterval))
    }

    throw JSONDeserializationError.invalidAttributeType(key: key, expectedType: String.self, receivedValue: value)
}


/// Decode a JSONDeserializable type from a given JSON dictionary.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter key: key in the dictionary
/// - returns: The expected JSONDeserializable value
/// - throws: JSONDeserializationError
public func decode<T: JSONDeserializable>(_ dictionary: [String: Any], key: String) throws -> T {
    let value: [String: Any] = try decode(dictionary, key: key)
    return try decode(value)
}


/// Decode a JSONDeserializable type
///
/// - parameter dictionary: a JSON dictionary
/// - returns: the decoded type
/// - throws: JSONDeserializationError
public func decode<T: JSONDeserializable>(_ dictionary: [String: Any]) throws -> T {
    return try T.init(jsonRepresentation: dictionary)
}

func ISO8601DateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

    return formatter
}

