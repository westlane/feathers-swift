//
//  AuthenticationConfiguration.swift
//  Feathers
//
//  Created by Brendan Conron on 4/16/17.
//  Copyright © 2017 FeathersJS. All rights reserved.
//

import Foundation

public struct AuthenticationConfiguration {

    /// Authorization header field in requests.
    public let header: String

    /// Path for authentication service.
    public let path: String

    /// Strategy name for jwt authentication.
    public let jwtStrategy: String

    /// The entity you are authenticating.
    public let entity: String

    /// The service to look up the entity
    public let service: String

    // The key to store the accessToken with.
    public let storageKey: String
    
    /// Whether to use secure keychain storage (true) or in-memory storage (false)
    /// Default is true for production, set to false for demos/testing to avoid keychain prompts
    public let useSecureStorage: Bool

    public init(
        header: String = "Authorization",
        path: String = "/authentication",
        jwtStrategy: String = "jwt",
        entity: String = "user",
        service: String = "users",
        storageKey: String = "feathers-jwt",
        useSecureStorage: Bool = true) {
        self.header = header
        self.path = path
        self.jwtStrategy = jwtStrategy
        self.entity = entity
        self.service = service
        self.storageKey = storageKey
        self.useSecureStorage = useSecureStorage
    }
}
