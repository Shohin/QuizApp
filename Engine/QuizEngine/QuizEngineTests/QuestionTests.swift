//
//  QuestionTests.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 23/12/20.
//

import XCTest
@testable import QuizEngine

final class QuestionTests: XCTestCase {
    func testHashValueSingleAnswerReturnsTypeHash() {
        let type = "a string"
        
        let sut = Question.singleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func testHashValueMultipleAnswerReturnsTypeHash() {
        let type = "a string"
        
        let sut = Question.multipleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
}
