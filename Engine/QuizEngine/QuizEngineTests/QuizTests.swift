//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 07/01/21.
//

import Foundation
import XCTest
@testable import QuizEngine

final class Quiz {
    private let flow: Any
    init(flow: Any) {
        self.flow = flow
    }
    
    static func start<Delegate: QuizDelegate> (questions: [Delegate.Question], delegate: Delegate, correctAnswers: [Delegate.Question: Delegate.Answer]) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(questions: questions, delegate: delegate) {
            scoringGame(answers: $0, correctAnswers: correctAnswers)
        }
        flow.start()
        return Quiz(flow: flow)
    }
}

final class QuizTests: XCTestCase {
    private let delegate = DelegateSpy()
    private var quiz: Quiz!
    
    override func setUp() {
        super.setUp()
        quiz = Quiz.start(questions: ["Q1", "Q2"], delegate: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])
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
    
    private class DelegateSpy: QuizDelegate {
        var answerCallback: (String) -> Void = {_ in}
        var handledResult: Result<String, String>? = nil
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
    }
}
