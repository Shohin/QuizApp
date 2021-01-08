//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 07/01/21.
//

import Foundation
import XCTest
@testable import QuizEngine

final class QuizTests: XCTestCase {
    private let delegate = DelegateSpy()
    private var quiz: Game<String, String, DelegateSpy>!
    
    override func setUp() {
        super.setUp()
        quiz = startGame(questions: ["Q1", "Q2"], router: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    func testStartQuizAswerZeroOutOfTwoCorrectlyScoresZero() {
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    
    func testStartQuizAswerOneOutOfTwoCorrectlyScoresOne() {
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    
    func testStartQuizAswerTwoOutOfTwoCorrectlyScoresTwo() {
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
    
    private class DelegateSpy: Router, QuizDelegate {
        var answerCallback: (String) -> Void = {_ in}
        var handledResult: Result<String, String>? = nil
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }
    }
}
