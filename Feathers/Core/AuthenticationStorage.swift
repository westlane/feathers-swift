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
/// Session cache: token is read from keychain once per session to avoid repeated keychain prompts.
/// Cache is cleared on set(nil) (logout) so next access requires keychain again.
public final class EncryptedAuthenticationStore: AuthenticationStorage {

    private let keychain = KeychainSwift()
    private let storageKey: String
    /// Session cache so we only hit keychain once; cleared when token is set to nil (logout).
    private var _cachedToken: String?

    public var accessToken: String? {
        get {
            if let cached = _cachedToken { return cached }
            let value = keychain.get(storageKey)
            _cachedToken = value
            return value
        }
        set {
            _cachedToken = nil
            if let value = newValue {
                keychain.set(value, forKey: storageKey)
                _cachedToken = value
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
