//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 12/18/20.
//

import Foundation
import QuizEngine

class RouterSpy: Router {
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
