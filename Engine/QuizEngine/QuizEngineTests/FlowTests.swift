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
    private let router = RouterSpy()
    
    func testStartWithNoQuestionDoesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func testStartWithOneQuestionRoutesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStartWithOneQuestionsRoutesToCorrectQuestion2() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func testStartWithTwoQuestionsRoutesToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStartTwiceWithTwoQuestionsRoutesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithThreeQuestionsRoutesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func testStartAndAnswerToFirstQuestionWithOneQuestionDoesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func testStartWithNoQuestionRouteToResult() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(router.routedResult?.answers, [:])
    }
    
    func testStartWithOneQuestionsDoesNotRouteToResult() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertNil(router.routedResult)
    }
    
    func testStartAndAnswerToFirstQuestionWithTwoQuestionsDoesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        router.answerCallback("A1")
        
        XCTAssertNil(router.routedResult)
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithTwoQuestionsRouteToResult() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult?.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithTwoQuestionsScoring() {
        let sut = makeSUT(questions: ["Q1", "Q2"]) {_ in
            return 10
        }
        
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult?.score, 10)
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithTwoQuestionsScoresWithRightAnswers() {
        var receivedAnswers: [String: String]?
        let sut = makeSUT(questions: ["Q1", "Q2"]) { answers in
            receivedAnswers = answers
            return 12
        }
        
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }
    
    //MARK: Helpers
    private func makeSUT(questions: [String], scoring: @escaping ([String: String]) -> Int = {_ in return 0}) -> Flow<String, String, RouterSpy> {
        Flow(questions: questions, router: router, scoring: scoring)
    }
}

private class RouterSpy: Router {
    var routedQuestions: [String] = []
    var answerCallback: (String) -> Void = {_ in}
    var routedResult: Result<String, String>? = nil
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}
