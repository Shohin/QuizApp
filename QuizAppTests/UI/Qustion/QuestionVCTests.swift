//
//  QuestionVCTests.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 12/15/20.
//

import XCTest
@testable import QuizApp

class QuestionVCTests: XCTestCase {
    func testViewDidLoadRendersQuestionHeaderText() {
        XCTAssertTrue(makeSUT(question: "Q1").headerLabel.text == "Q1")
    }
    
    func testViewDidLoadRendersOptions() {
        XCTAssertTrue(makeSUT(options: []).tableView.numberOfRows(inSection: 0) == 0)
        XCTAssertTrue(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0) == 1)
        XCTAssertTrue(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0) == 2)
    }
    
    func testViewDidLoadRendersOptionsText() {
        XCTAssertTrue(makeSUT(options: ["A1", "A2"]).tableView.title(at: 0) == "A1")
        XCTAssertTrue(makeSUT(options: ["A1", "A2"]).tableView.title(at: 1) == "A2")
    }
    
    func testViewDidWithSingleSelectionConfiguresTableView() {
        XCTAssertFalse(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false).tableView.allowsMultipleSelection)
    }
    
    func testViewDidWithMultipleSelectionConfiguresTableView() {
        XCTAssertTrue(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true).tableView.allowsMultipleSelection)
    }
    
    func testOptionSelectedSingleSelectionNotifiesDelegateWithLastSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { receivedAnswer = $0 }
        
        sut.tableView.select(at: 0)
        XCTAssertTrue(receivedAnswer == ["A1"])
        
        sut.tableView.select(at: 1)
        XCTAssertTrue(receivedAnswer == ["A2"])
    }
    
    func testOptionDeselectedSingleSelectionDoesNotNotifyDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { _ in callbackCount += 1 }
        
        sut.tableView.select(at: 0)
        XCTAssertTrue(callbackCount == 1)
        
        sut.tableView.deselect(at: 0)
        XCTAssertTrue(callbackCount == 1)
    }
    
    func testOptionSelectedWithMultipleSelectionEnabledNotifiesDelegateSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswer = $0 }
        
        sut.tableView.select(at: 0)
        XCTAssertTrue(receivedAnswer == ["A1"])

        sut.tableView.select(at: 1)
        XCTAssertTrue(receivedAnswer == ["A1", "A2"])
    }
    
    func testOptionDeselectedWithMultipleSelectionEnabledNotifiesDelegate() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswer = $0 }
        
        sut.tableView.select(at: 0)
        XCTAssertTrue(receivedAnswer == ["A1"])

        sut.tableView.deselect(at: 0)
        XCTAssertTrue(receivedAnswer == [])
    }
    
    //MARK: Helpers
    private func makeSUT(question: String = "",
                         options: [String] = [],
                         allowsMultipleSelection: Bool = false,
                         selection: @escaping ([String]) -> Void = {_ in}) -> QuestionVC {
        let vc = QuestionVC(question: question, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: selection)
        _ = vc.view
        return vc
    }
}
