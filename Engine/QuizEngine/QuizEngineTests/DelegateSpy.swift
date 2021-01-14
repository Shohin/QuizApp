//
//  DelegateSpy.swift
//  QuizEngineTests
//
//  Created by Shohin Tagaev on 14/01/21.
//

import Foundation
import QuizEngine

final class DelegateSpy: QuizDelegate {
    var questionsAsked: [String] = []
    var completedQuizzes: [[(String, String)]] = []
    
    var answerCompletions: [(String) -> Void] = []
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
}
