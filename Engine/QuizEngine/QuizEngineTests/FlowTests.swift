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
        
        XCTAssertTrue(delegate.questionsAsked.isEmpty)
    }
    
    func testStartWithOneQuestionDelegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func testStartWithOneQuestionsDelegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(delegate.questionsAsked, ["Q2"])
    }
    
    func testStartWithTwoQuestionsDelegatesFirstQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func testStartTwiceWithTwoQuestionsDelegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q1"])
    }
    
    func testStartAndAnswerToFirstAndSecondQuestionWithThreeQuestionsDelegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q2", "Q3"])
    }
    
    func testStartAndAnswerToFirstQuestionWithOneQuestionDoesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func testStartWithOneQuestions_doesNotCompleteQuiz() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestion_completeWithEmptyQuiz() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_completesQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqueal(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    //MARK: Helpers
    private func makeSUT(questions: [String]) -> Flow<DelegateSpy> {
        Flow(questions: questions, delegate: delegate)
    }
    
    private func assertEqueal(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(a1.elementsEqual(a2, by: ==), "\(a1) is not equal to: \(a2)", file: file, line: line)
    }
    
    private class DelegateSpy: QuizDelegate {
        var questionsAsked: [String] = []
        var handledResult: Result<String, String>? = nil
        var completedQuizzes: [[(String, String)]] = []
        
        var answerCompletions: [(String) -> Void] = []
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            questionsAsked.append(question)
            answerCompletions.append(completion)
        }
        
        func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
            completedQuizzes.append(answers)
        }
        
        func handle(result: Result<String, String>) {
            handledResult = result
        }
    }
}
