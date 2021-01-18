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
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    func testTitleReturnsFormattedTitle() {        
        XCTAssertEqual(makeSUT().title, "Result")
    }
    
    func testSummaryWithTwoQuestionsAndScoreOneReturnsSummary() {
        let answers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A2", "A3"]]
        
        let result = Result.make(answers: answers, score: 1)
        
        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion, multipleAnswerQuestion], correctAnswers: answers)
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func testPresentableAnswersWithoutQuestionsIsEmpty() {
        let answers = [Question<String>: [String]]()
        
        let result = Result.make(answers: answers)
        
        let sut = ResultsPresenter(result: result, questions: [], correctAnswers: [:])
        
        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func testPresentableAnswersWithWrongSingleAnswerMapsAnswers() {
        let answers = [singleAnswerQuestion: ["A1"]]
        let correctAnswers = [singleAnswerQuestion: ["A2"]]
        let result = Result.make(answers: answers)
        
        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion], correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func testPresentableAnswersWithWrongMultipleAnswerMapsAnswers() {
        let answers = [multipleAnswerQuestion: ["A1", "A4"]]
        let correctAnswers = [multipleAnswerQuestion: ["A2", "A3"]]
        let result = Result.make(answers: answers)
        
        let sut = ResultsPresenter(result: result, questions: [multipleAnswerQuestion], correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    func testPresentableAnswersWithTwoQuestionMapsOrderedAnswers() {
        let answers = [Question.multipleAnswer("Q2"): ["A1", "A4"], Question.singleAnswer("Q1"): ["A2"]]
        let correctAnswers = [Question.multipleAnswer("Q2"): ["A1", "A4"], Question.singleAnswer("Q1"): ["A2"]]
        let result = Result.make(answers: answers, score: 1)
        let orderedQuestions = [Question.singleAnswer("Q1"), Question.multipleAnswer("Q2")]

        let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)

        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }
    
    //MARK: Helpers
    private func makeSUT() -> ResultsPresenter {
        ResultsPresenter(userAnswers: [], correctAnswers: [], scorer: {_,_ in 0})
    }
}
