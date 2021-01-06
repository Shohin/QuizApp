//
//  FlowTests.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 12/13/20.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTests: XCTestCase {
    private let delegate = DelegateSpy()
    
    func testStartWithNoQuestionDoesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func testStartWithOneQuestionRoutesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func testStartWithOneQuestionsRoutesToCorrectQuestion2() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }
    
    func testStartWithTwoQuestionsRoutesToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func testStartTwiceWithTwoQuestionsRoutesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithThreeQuestionsRoutesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func testStartAndAnswerToFirstQuestionWithOneQuestionDoesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        delegate.answerCallback("A1")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func testStartWithNoQuestionRouteToResult() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.handledResult?.answers, [:])
    }
    
    func testStartWithOneQuestionsDoesNotRouteToResult() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertNil(delegate.handledResult)
    }
    
    func testStartAndAnswerToFirstQuestionWithTwoQuestionsDoesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        delegate.answerCallback("A1")
        
        XCTAssertNil(delegate.handledResult)
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithTwoQuestionsRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult?.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithTwoQuestionsScoring() {
        let sut = makeSUT(questions: ["Q1", "Q2"]) {_ in
            return 10
        }
        
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult?.score, 10)
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithTwoQuestionsScoresWithRightAnswers() {
        var receivedAnswers: [String: String]?
        let sut = makeSUT(questions: ["Q1", "Q2"]) { answers in
            receivedAnswers = answers
            return 12
        }
        
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    //MARK: Helpers
    private func makeSUT(questions: [String], scoring: @escaping ([String: String]) -> Int = {_ in return 0}) -> Flow<String, String, DelegateSpy> {
        Flow(questions: questions, router: delegate, scoring: scoring)
    }
    
    private class DelegateSpy: Router, QuizDelegate {
        var handledQuestions: [String] = []
        var answerCallback: (String) -> Void = {_ in}
        var handledResult: Result<String, String>? = nil
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
        
        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }
    }
}
