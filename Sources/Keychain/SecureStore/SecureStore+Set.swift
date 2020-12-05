//
//  SecureStore+Set.swift
//  
//
//  Created by Rostyslav Druzhchenko on 05.12.2020.
//

import Foundation

public extension SecureStore {

    func setValue(_ value: String, for userAccount: String) throws {

        guard let data = value.data(using: .utf8) else {
            throw SecureStoreError.string2DataConversionError
        }

        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            try update(data, query)
        case errSecItemNotFound:
            try create(data, &query)
        default:
            throw error(from: status)
        }
    }

    private func update(_ data: Data, _ query: Query) throws {

        var attributesToUpdate: Query = [:]
        attributesToUpdate[String(kSecValueData)] = data
        let status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
        try throwIfNotSucceded(status)
    }

    private func create(_ data: Data, _ query: inout Query) throws {

        query[String(kSecValueData)] = data
        let status = SecItemAdd(query as CFDictionary, nil)
        try throwIfNotSucceded(status)
    }

    private func throwIfNotSucceded(_ status: OSStatus) throws {
        if status != errSecSuccess {
            throw error(from: status)
        }
    }
}
