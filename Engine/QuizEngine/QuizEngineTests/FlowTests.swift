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
    
    func testStartWithNoQuestionDoesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func testStartWithOneQuestionDelegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func testStartWithOneQuestionsDelegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }
    
    func testStartWithTwoQuestionsDelegatesFirstQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func testStartTwiceWithTwoQuestionsDelegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithThreeQuestionsDelegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func testStartAndAnswerToFirstQuestionWithOneQuestionDoesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        delegate.answerCallback("A1")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func testStartWithNoQuestionDelegateResultHandling() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.handledResult?.answers, [:])
    }
    
    func testStartWithOneQuestionsDoesNotDelegateResultHandling() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertNil(delegate.handledResult)
    }
    
    func testStartAndAnswerToFirstQuestionWithTwoQuestionsDoesNotDelegateResultHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        delegate.answerCallback("A1")
        
        XCTAssertNil(delegate.handledResult)
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithTwoQuestionsDelegateResultHandling() {
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
    private func makeSUT(questions: [String], scoring: @escaping ([String: String]) -> Int = {_ in return 0}) -> Flow<DelegateSpy> {
        Flow(questions: questions, delegate: delegate, scoring: scoring)
    }
    
    private class DelegateSpy: QuizDelegate {
        var handledQuestions: [String] = []
        var answerCallback: (String) -> Void = {_ in}
        var handledResult: Result<String, String>? = nil
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
    }
}
