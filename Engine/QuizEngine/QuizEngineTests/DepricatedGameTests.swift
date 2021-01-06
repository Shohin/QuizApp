//
//  DepricatedGameTests.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 12/18/20.
//

import Foundation
import XCTest
import QuizEngine

@available(*, deprecated)
final class DepricatedGameTests: XCTestCase {
    private let router = RouterSpy()
    private var game: Game<String, String, RouterSpy>!
    
    override func setUp() {
        super.setUp()
        game = startGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    func testStartGameAswerZeroOutOfTwoCorrectlyScoresZero() {
        router.answerCallback("wrong")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    
    func testStartGameAswerOneOutOfTwoCorrectlyScoresOne() {
        router.answerCallback("A1")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    
    func testStartGameAswerTwoOutOfTwoCorrectlyScoresTwo() {
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!.score, 2)
    }
}

@available(*, deprecated)
private class RouterSpy: Router {
    var answerCallback: (String) -> Void = {_ in}
    var routedResult: Result<String, String>? = nil
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        self.answerCallback = answerCallback
    }
    
    func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}
