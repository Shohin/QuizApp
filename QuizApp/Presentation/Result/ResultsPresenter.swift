//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Shohin Tagaev on 26/12/20.
//

import Foundation
import QuizEngine

struct ResultsPresenter {
    let result: Result<Question<String>, [String]>
    let questions: [Question<String>]
    let correctAnswers: [Question<String>: [String]]
    
    var title: String {
        "Result"
    }
    
    var summary: String {
        "You got \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        questions.map { (question) in
            guard let userAnswers = result.answers[question],
                  let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn't find correct answer for question: \(question)")
            }
            return presentableAnswer(question, userAnswers, correctAnswer)
        }
    }
    
    private func presentableAnswer(_ question: Question<String>, _ userAnswers: [String], _ correctAnswer: [String]) -> PresentableAnswer {
        switch question {
        case .singleAnswer(let value),
             .multipleAnswer(let value):
            return PresentableAnswer(
                question: value,
                answer: formattedAnswer(correctAnswer),
                wrongAnswer: formattedWrongAnswer(userAnswers, correctAnswer))
        }
    }
    
    private func formattedAnswer(_ answer: [String]) -> String {
        answer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(_ userAnswer: [String], _ correctAnswer: [String]) -> String? {
        correctAnswer == userAnswer ? nil : formattedAnswer(userAnswer)
    }
}
