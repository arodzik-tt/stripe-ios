//
//  STPAPIClient+ErrorResponseTest.swift
//  StripeCoreTests
//
//  Created by Eduardo Urias on 9/30/22.
//

import XCTest
@_spi(STP) import StripeCore

class STPAPIClient_ErrorResponseTest: XCTestCase {
    /// Response is an error, error code is a known error code, so the `localizedDescription` should be overridden by a default error code .
    func testResponse_WithKnownErrorCode() throws {
        let response = [
            "error": [
                "type": "card_error",
                "message": "some message",
                "code": "incorrect_number",
            ]
        ]

        let responseData = try JSONSerialization.data(withJSONObject: response, options: [])
        let result: Result<EmptyResponse, Error> = STPAPIClient.decodeResponse(data: responseData, error: nil, response: nil)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, NSError.stp_cardErrorInvalidNumberUserMessage())
        case .success:
            XCTFail("The request should not have succeeded")
        }
    }

    /// Response is an error, error code is not present.
    func testResponse_WithNoErrorCode() throws {
        let response = [
            "error": [
                "type": "card_error",
                "message": "some message",
            ]
        ]

        let responseData = try JSONSerialization.data(withJSONObject: response, options: [])
        let result: Result<EmptyResponse, Error> = STPAPIClient.decodeResponse(data: responseData, error: nil, response: nil)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "some message")
        case .success:
            XCTFail("The request should not have succeeded")
        }
    }
    
    
    /// Response is an error, error code is empty.
    func testResponse_WithEmptyErrorCode() throws {
        let response = [
            "error": [
                "type": "card_error",
                "message": "some message",
                "code": "",
            ]
        ]

        let responseData = try JSONSerialization.data(withJSONObject: response, options: [])
        let result: Result<EmptyResponse, Error> = STPAPIClient.decodeResponse(data: responseData, error: nil, response: nil)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "some message")
        case .success:
            XCTFail("The request should not have succeeded")
        }
    }
    
    /// Response is an error, error code is invalid.
    func testResponse_WithInvalidErrorCode() throws {
        let response = [
            "error": [
                "type": "card_error",
                "message": "some message",
                "code": "garbage",
            ]
        ]

        let responseData = try JSONSerialization.data(withJSONObject: response, options: [])
        let result: Result<EmptyResponse, Error> = STPAPIClient.decodeResponse(data: responseData, error: nil, response: nil)

        switch result {
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, "some message")
        case .success:
            XCTFail("The request should not have succeeded")
        }
    }
}
