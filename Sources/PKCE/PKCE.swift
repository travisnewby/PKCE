//
//  PKCE.swift
//
//  Created by Travis on 7/7/21.
//

import Foundation
import CryptoKit


///
/// An easy-to-use implementation of the client side of the [PKCE standard](https://datatracker.ietf.org/doc/html/rfc7636).
///
struct PKCE {
    
    typealias PKCECode = String
    private static let allBase64 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    /// A high-entropy cryptographic random value, as described in [Section 4.1](https://datatracker.ietf.org/doc/html/rfc7636#section-4.1) of the PKCE standard.
    let codeVerifier: PKCECode
    
    /// A transformation of the codeVerifier, as defined in [Section 4.2](https://datatracker.ietf.org/doc/html/rfc7636#section-4.2) of the PKCE standard.
    let codeChallenge: PKCECode
    
    ///
    /// Create a PKCE instance with a random code verifier and calculated challenge.
    ///
    ///
    init() throws {
        
        codeVerifier = PKCE.generateRandomCodeVerifier()
        codeChallenge = try PKCE.codeChallenge(fromVerifier: codeVerifier)
    }
    
    ///
    /// Creates a code challenge given a code verifier.
    ///
    /// This will fail if the characters in the verifier are not base64.
    ///
    static func codeChallenge(fromVerifier verifier: PKCECode) throws -> PKCECode {
        
        print("Verifier is \(verifier)")
        
        guard let verifierData = verifier.data(using: .ascii) else { throw PKCEError.improperlyFormattedVerifier }
        
        let challengeHashed = SHA256.hash(data: verifierData)
        let challengeBase64Encoded = Data(challengeHashed).base64URLEncodedString
        
        print("Base 64 encoded is \(challengeBase64Encoded)")
        
        return challengeBase64Encoded
    }
    
    enum PKCEError: Error {
        
        case failedToGenerateRandomOctets
        case improperlyFormattedVerifier
    }
}

extension PKCE {
    
    ///
    /// Generates a random code verifier (as defined in [Seciton 4.1 of the PKCE standard](https://datatracker.ietf.org/doc/html/rfc7636#section-4.1)).
    ///
    /// This method first attempts to use CryptoKit to generate random bytes. If it fails to generate those random bytes, it falls back on a generic
    /// Base64 random string generator.
    ///
    static func generateRandomCodeVerifier() -> PKCECode {
        
        do {
            
            let rando = try PKCE.generateCryptographicallySecureRandomOctets(count: 32)
            return Data(bytes: rando, count: rando.count).base64URLEncodedString
            
        } catch {
            
            return generateBase64RandomString(ofLength: 43)
        }
    }
    
    private static func generateCryptographicallySecureRandomOctets(count: Int) throws -> [UInt8] {
        
        var octets = [UInt8](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, octets.count, &octets)
        
        if status == errSecSuccess {
            
            return octets
            
        } else {
            
            throw PKCEError.failedToGenerateRandomOctets
        }
    }
    
    private static func generateBase64RandomString(ofLength length: UInt8) -> PKCECode {
        
        return String((0..<length).map{ _ in allBase64.randomElement()! })
    }
}
