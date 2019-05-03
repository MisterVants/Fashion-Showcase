//
//  NetworkClientSpec.swift
//  FashionShowcaseTests
//
//  Created by André Vants Soares de Almeida on 02/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import Quick
import Nimble

@testable import FashionShowcase

class NetworkClientSpec: QuickSpec {

    override func spec() {
        
        var targetUrl: URL!
        var client: NetworkClient!
        var sessionMock: URLSessionMock!
        
        beforeSuite {
            targetUrl = URL(string: "https://httpbin.org/get")
        }
        
        beforeEach {
            sessionMock = URLSessionMock()
            client = NetworkClient(session: sessionMock)
            client.clearCache()
        }
        
        describe("response checkouts") {
            
            context("when there is a network error") {
                it("should callback a network error") {
                    sessionMock.taskError = NSError(domain: "testError", code: 0, userInfo: nil)
                    waitUntil { done in
                        client.getData(at: targetUrl, completion: { result in
                            switch result {
                            case .success: fail()
                            case .failure(let error):
                                expect(error.isNetworkError).to(beTrue())
                            }
                            done()
                        })
                    }
                }
            }
            
            context("when there is no response") {
                it("should callback a no response error") {
                    waitUntil { done in
                        client.getData(at: targetUrl, completion: { result in
                            switch result {
                            case .success: fail()
                            case .failure(let error):
                                expect(error.isNoResponseError).to(beTrue())
                            }
                            done()
                        })
                    }
                }
            }
            
            context("when the response status code is not a success") {
                it("should callback a bad status code error") {
                    sessionMock.taskResponse = HTTPURLResponse(url: targetUrl, statusCode: 404, httpVersion: nil, headerFields: nil)
                    waitUntil { done in
                        client.getData(at: targetUrl, completion: { result in
                            switch result {
                            case .success: fail()
                            case .failure(let error):
                                expect(error.isBadStatusCodeError).to(beTrue())
                            }
                            done()
                        })
                    }
                }
            }
            
            context("when the received data is nil") {
                it("should callback a nil data error") {
                    sessionMock.taskResponse = HTTPURLResponse(url: targetUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
                    waitUntil { done in
                        client.getData(at: targetUrl, completion: { result in
                            switch result {
                            case .success: fail()
                            case .failure(let error):
                                expect(error.isNilDataError).to(beTrue())
                            }
                            done()
                        })
                    }
                }
            }
            
            context("when the data is valid") {
                it("should callback a success") {
                    sessionMock.taskResponse = HTTPURLResponse(url: targetUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
                    sessionMock.taskData = "data".data(using: .utf8)
                    waitUntil { done in
                        client.getData(at: targetUrl, completion: { result in
                            let value = try? result.get()
                            expect(value).toNot(beNil())
                            done()
                        })
                    }
                }
            }
        }
    }

}
