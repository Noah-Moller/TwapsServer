//
//  File.swift
//  TwapsServer
//
//  Created by Noah Moller on 7/3/2025.
//

import Foundation

/**
 * Twap
 *
 * A model that represents a Twap in the TwapsServer.
 * This model is used for storing and retrieving Twaps from the server.
 *
 * A Twap consists of:
 * - source: The Swift source code of the Twap (with escaped newlines)
 * - url: The URL where the Twap is accessible
 * - id: A unique identifier for the Twap
 */
struct Twap: Codable, Identifiable {
    /// The source code of the Twap (with escaped newlines)
    let source: String
    
    /// The URL where the Twap is accessible
    let url: String
    
    /// A unique identifier for the Twap
    let id: String
}
