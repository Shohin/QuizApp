//
//  QuestionPresenterTests.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 27/12/20.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

final class QuestionPresenterTests: XCTestCase {
    let question1 = Question.singleAnswer("Q1")
    let question2 = Question.multipleAnswer("Q1")
    
    func test_title_forFirstQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question1)
        XCTAssertEqual(sut.title, "Question #1")
    }
    
    func test_title_forSecondQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)
        XCTAssertEqual(sut.title, "Question #2")
    }
    
    func test_title_forUnexitenQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [], question: question1)
        XCTAssertTrue(sut.title.isEmpty)
    }
}
