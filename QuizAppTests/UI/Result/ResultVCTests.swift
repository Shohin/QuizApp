//
//  ResultVCTests.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 12/16/20.
//

import XCTest
@testable import QuizApp

final class ResultVCTests: XCTestCase {
    func testViewDidLoadRenderSummary() {
        XCTAssertEqual(makeSUT(summary: "a summary").headerLabel.text, "a summary")
    }
    
    func testViewDidLoadRenderAnswers() {
        XCTAssertEqual(makeSUT(answers: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(answers: [makeAnswer()]).tableView.numberOfRows(inSection: 0), 1)
    }
    
    func testViewDidLoadWithCorrectAnswersRenderConfiguresCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1", answer: "A1")])
        
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }
    
    func testViewDidLoadWithWrongAnswersRenderConfiguresCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1", answer: "A1", wrongAnswer: "A2")])
        
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
        XCTAssertEqual(cell?.wrongAnswerLabel.text, "A2")
    }
    
    //MARK: Helpers
    private func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultVC {
        let vc = ResultVC(summary: summary, answers: answers)
        _ = vc.view
        return vc
    }
    
    private func makeAnswer(question: String = "", answer: String = "", wrongAnswer: String? = nil) -> PresentableAnswer {
        PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer)
    }
}
