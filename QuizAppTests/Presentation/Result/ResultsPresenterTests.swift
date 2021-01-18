//
//  ResultsPresenterTests.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 26/12/20.
//

import XCTest
import QuizEngine
@testable import QuizApp

final class ResultsPresenterTests: XCTestCase {
    func testTitleReturnsFormattedTitle() {
        XCTAssertEqual(makeSUT().title, "Result")
    }
    
    func testSummaryWithTwoQuestionsAndScoreOneReturnsSummary() {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A2", "A3"])]
                
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: userAnswers, score: 1)
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func testPresentableAnswersWithoutQuestionsIsEmpty() {
        XCTAssertTrue(makeSUT().presentableAnswers.isEmpty)
    }
    
    func testPresentableAnswersWithWrongSingleAnswerMapsAnswers() {
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        let correctAnswers = [(singleAnswerQuestion, ["A2"])]
        
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func testPresentableAnswersWithWrongMultipleAnswerMapsAnswers() {
        let userAnswers = [(multipleAnswerQuestion, ["A1", "A4"])]
        let correctAnswers = [(multipleAnswerQuestion, ["A2", "A3"])]
        
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    func testPresentableAnswersWithTwoQuestionMapsOrderedAnswers() {
        let userAnswers = [(Question.singleAnswer("Q1"), ["A2"]), (Question.multipleAnswer("Q2"), ["A1", "A4"])]
        let correctAnswers = [(Question.singleAnswer("Q1"), ["A2"]), (Question.multipleAnswer("Q2"), ["A1", "A4"])]
        
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers, score: 1)

        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)

        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }
    
    //MARK: Helpers
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    private func makeSUT(userAnswers: ResultsPresenter.Answers = [],
                         correctAnswers: ResultsPresenter.Answers = [],
                         score: Int = 0) -> ResultsPresenter {
        ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: {_, _ in score })
    }
}
