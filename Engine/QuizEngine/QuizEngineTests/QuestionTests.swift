//
//  QuestionTests.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 23/12/20.
//

import XCTest
@testable import QuizEngine

final class QuestionTests: XCTestCase {
    func testHashValue_withSameWrappedValue_isDifferentForSingleAndMultipleAnswer() {
        let aValue = UUID()
            
        XCTAssertNotEqual(Question.singleAnswer(aValue).hashValue, Question.multipleAnswer(aValue).hashValue)
    }
    
    func testHashValue_forSingleAnswer() {
        let aValue = UUID()
        let anotherValue = UUID()
        
        XCTAssertEqual(Question.singleAnswer(aValue).hashValue, Question.singleAnswer(aValue).hashValue)
    
        XCTAssertNotEqual(Question.singleAnswer(aValue).hashValue, Question.singleAnswer(anotherValue).hashValue)
    }
    
    func testHashValue_forMultipleAnswer() {
        let aValue = UUID()
        let anotherValue = UUID()
        
        XCTAssertEqual(Question.multipleAnswer(aValue).hashValue, Question.multipleAnswer(aValue).hashValue)
    
        XCTAssertNotEqual(Question.multipleAnswer(aValue).hashValue, Question.multipleAnswer(anotherValue).hashValue)
    }
}
