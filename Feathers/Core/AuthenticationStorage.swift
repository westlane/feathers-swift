//
//  AuthenticationStorage.swift
//  Feathers
//
//  Created by Brendan Conron on 5/3/17.
//  Copyright © 2017 FeathersJS. All rights reserved.
//

import Foundation
import KeychainSwift

/// Authentication storage protocol.
public protocol AuthenticationStorage: AnyObject {

    init(storageKey: String)
    var accessToken: String? { get set }

}

/// An encrypted authentication store. Uses the keychain to store a token.
public final class EncryptedAuthenticationStore: AuthenticationStorage {

    private let keychain = KeychainSwift()
    private let storageKey: String

    public var accessToken: String? {
        get { return keychain.get(storageKey) }
        set {
            if let value = newValue {
                keychain.set(value, forKey: storageKey)
            } else {
                keychain.delete(storageKey)
            }
        }
    }

    public init(storageKey: String = "feathers-jwt") {
        self.storageKey = storageKey
    }

}

/// An in-memory authentication store. Simple storage for demos/testing that doesn't require keychain.
public final class InMemoryAuthenticationStore: AuthenticationStorage {
    
    private var token: String?
    private let storageKey: String
    
    public var accessToken: String? {
        get { return token }
        set { token = newValue }
    }
    
    public init(storageKey: String = "feathers-jwt") {
        self.storageKey = storageKey
    }
    
}
