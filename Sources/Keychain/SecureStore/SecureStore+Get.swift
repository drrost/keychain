//
//  SecureStore+Get.swift
//  
//
//  Created by Rostyslav Druzhchenko on 05.12.2020.
//

import Foundation

public extension SecureStore {

    func getValue(for userAccount: String) throws -> String? {

        let query = composeQuery(userAccount)

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            return try fetchPassword(queryResult)
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }

    private func composeQuery(_ userAccount: String) -> Query {
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = userAccount
        return query
    }

    private func fetchPassword(_ queryResult: AnyObject?) throws -> String? {

        guard
            let queriedItem = queryResult as? [String: Any],
            let passwordData = queriedItem[String(kSecValueData)] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
        else {
            throw SecureStoreError.data2StringConversionError
        }
        return password
    }
}
