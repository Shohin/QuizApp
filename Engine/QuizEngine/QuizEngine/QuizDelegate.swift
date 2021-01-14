//
//  QuizDelegate.swift
//  QuizEngine
//
//  Created by Shohin Tagaev on 07/01/21.
//

import Foundation

public protocol QuizDelegate {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
}
