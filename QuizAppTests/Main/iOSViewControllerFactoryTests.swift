//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 25/12/20.
//

import XCTest
@testable import QuizApp
@testable import QuizEngine

final class iOSViewControllerFactoryTests: XCTestCase {
    let options = ["A1", "A2"]
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    func testQuestionViewControllerSingleAnswerCreatesControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, presenter.title)
    }

    func testQuestionViewControllerSingleAnswerCreatesControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func testQuestionViewControllerSingleAnswerCreatesControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).options, options)
    }
    
    func testQuestionViewControllerSingleAnswerCreatesControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionController(question: singleAnswerQuestion).allowsMultipleSelection)
    }
    
    func testQuestionViewControllerMultipleAnswerCreatesControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).title, presenter.title)
    }
    
    func testQuestionViewControllerMultipleAnswerCreatesControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q2")
    }
    
    func testQuestionViewControllerMultipleAnswerCreatesControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options)
    }
    
    func testQuestionViewControllerMultipleAnswerCreatesControllerWithSingleSelection() {
        XCTAssertTrue(makeQuestionController(question: multipleAnswerQuestion).allowsMultipleSelection)
    }
    
    func testResultViewController_createControllerWithTitle() {
        let results = makeResults()

        XCTAssertEqual(results.controller.title, results.presenter.title)
    }
    
    func testResultViewController_createControllerWithSummary() {
        let results = makeResults()

        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }
    
    func testResultViewController_createControllerWithPresentableAnswers() {
        let results = makeResults()
        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)

    }
    
    //MARK: Helpers
    func makeSUT(options: [Question<String>: [String]] = [:], correctAnswers: [Question<String>: [String]] = [:]) -> iOSViewControllerFactory {
        iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = .singleAnswer("")) -> QuestionVC {
        makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: {_ in}) as! QuestionVC
    }
    
    func makeResults() -> (controller: ResultVC, presenter: ResultsPresenter) {
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let userAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let result = Result.make(answers: userAnswers)

        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let controller = makeSUT(correctAnswers: correctAnswers).resultsViewController(for: result) as! ResultVC
        
        return (controller, presenter)
    }
}

private extension ResultsPresenter {
    convenience init(result: Result<Question<String>, [String]>,
         questions: [Question<String>],
         correctAnswers: [Question<String>: [String]]) {
        self.init(userAnswers: questions.map({ (question) in
            (question, result.answers[question]!)
        }),
        correctAnswers: questions.map({ (question) in
            (question, correctAnswers[question]!)
        }),
        scorer: {_, _ in result.score })
    }
}
