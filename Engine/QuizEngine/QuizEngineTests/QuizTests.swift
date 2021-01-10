//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 07/01/21.
//

import Foundation
import XCTest
import QuizEngine

final class QuizTests: XCTestCase {
    private let delegate = DelegateSpy()
    private var quiz: Quiz!
    
    override func setUp() {
        super.setUp()
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    func testStartQuizAswerZeroOutOfTwoCorrectlyScoresZero() {
        delegate.answerCompletion("wrong")
        delegate.answerCompletion("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    
    func testStartQuizAswerOneOutOfTwoCorrectlyScoresOne() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    
    func testStartQuizAswerTwoOutOfTwoCorrectlyScoresTwo() {
        delegate.answerCompletion("A1")
        delegate.answerCompletion("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
    
    private class DelegateSpy: QuizDelegate {
        var answerCompletion: (String) -> Void = {_ in}
        var handledResult: Result<String, String>? = nil
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
    }
}
