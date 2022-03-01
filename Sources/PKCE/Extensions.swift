//
//  File.swift
//  
//
//  Created by Travis on 2/16/22.
//

import Foundation

extension Data {
    
    ///
    /// Returns a Base64 URL-encoded string _without_ padding.
    ///
    /// This string is compatible with the PKCE Code generation process, and uses the algorithm as defined in the [PKCE standard](https://datatracker.ietf.org/doc/html/rfc7636#appendix-A).
    ///
    var base64URLEncodedString: String {
    
        base64EncodedString()
            .replacingOccurrences(of: "=", with: "") // Remove any trailing '='s
            .replacingOccurrences(of: "+", with: "-") // 62nd char of encoding
            .replacingOccurrences(of: "/", with: "_") // 63rd char of encoding
            .trimmingCharacters(in: .whitespaces)
    }
}

extension String {
    
    ///
    /// Returns true if all characters in this string match any of the characters in otherString. Otherwise, returns false.
    ///
    /// For example, if this string is aba and other string is abc, this returns true. If this string is abd and otherString
    /// is abc, this returns false because d is not in abc.
    ///
    func allCharactersIn(otherString: String) -> Bool {
        
        return allSatisfy { otherString.contains($0) }
    }
}
