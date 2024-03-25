//
//  Authentication.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/8/24.
//

import Foundation
import LocalAuthentication

class Authentication {
    
    static func authenticate(reason: String = "Authenticate to access sensitive data.") async throws -> Bool {
        #if !os(tvOS)
        let context = LAContext()
        var deviceError: NSError?
        var deviceBioError: NSError?

        
        let deviceOwner = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &deviceError)
        let deviceOwnerBio = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &deviceBioError)
        

        if deviceOwnerBio {
            return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
        } else if deviceOwner {
            return try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
        } else {
            if let deviceBioError {
                throw deviceBioError
            } else if let deviceError {
                throw deviceError
            } else {
                return false
            }
        }
        #else
        throw Error.noAuthentication
        #endif
    }
    
    enum Error: Swift.Error {
        case noAuthentication, didNotAuthenticate
    }
}
