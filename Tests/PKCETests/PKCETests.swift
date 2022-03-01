import XCTest

@testable import PKCE

final class PKCETests: XCTestCase {
    
    
    func testInitialization() throws {
        
        for _ in 0..<1000 {
            XCTAssertNotNil(try? PKCE(), "PKCE Initialization Failed")
        }
    }
    
    func testChallengeFromVerifier() throws {
        
        let knownPairs: [(verifier: String, challenge: String)] = [
            (verifier: "CKinymBYV9hYAOFF1B_K0_JIQmvIiLLo4bj6lWzuPthJhob5E1ZasTdbo6w~oA_YbyIzPc0Anz3BEwuQULAzgy0YHEXcIelqtOaRwKRsQ_kvNBHUc63IHwjf4I9MSqDa",
             challenge: "GBhCWdN-w9J296EqXi8TUa0NN9zmlJWMJFCfCYj6OvM"),
            (verifier: "AIdRkLc906IT12qBtM8XpAXjAr1ty4F8bfJbYotO1KxpXIhUcpoFAnG~qZ8Of54v5irKVvvHcBlYYQpnmy7G96ZfNDnc_CuSL3XX-d8p6lwad8Wy8tjgLeuGdgDGntxJ",
             challenge: "dfDsJWGCi6ig3sW2YwjZsCXvmHwqDPsHe-_htylrnrk"),
            (verifier: "Gq.G6EdU6oPbYcfi-6uv_ed5YfCR7npL9OoJLKDCPF~geQo~xXvtuwepB7PW1qf2~N_F5cY--C7v9iSihJdu_GFzZUhW8ZQeLMt0s4mTKW0Ol4a.eF~56drMoQ~Oo6rI",
             challenge: "eNfvaxQw0A5yfL8hJMGeniqT04mFQaJ1GzRIgLLQe3I")
        ]
        
        for pair in knownPairs {
        
            let calculatedChallenge = try PKCE.codeChallenge(fromVerifier: pair.verifier)
            
            XCTAssertEqual(pair.challenge, calculatedChallenge)
            
        }
    }
    
    func testGenerateRandomCodeVerifier() {
        
        for _ in 0..<1000 {
            let cv = PKCE.generateRandomCodeVerifier()
            
            XCTAssertEqual(cv.count, 43) // must be 43 chars in length
            XCTAssertNotNil(cv.data(using: .ascii)) // must be ascii-only
        }
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(PKCE().text, "Hello, World!")
    }
}
