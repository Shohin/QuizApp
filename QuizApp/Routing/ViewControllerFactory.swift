//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Shohin Tagaev on 25/12/20.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    typealias Answers = [(question: Question<String>, answers: [String])]
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    
    func resultsViewController(for userAnswers: Answers) -> UIViewController
    
    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
