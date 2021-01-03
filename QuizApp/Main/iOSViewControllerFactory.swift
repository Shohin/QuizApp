//
//  iOSViewControllerFactory.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 25/12/20.
//

import UIKit
import QuizEngine

final class iOSViewControllerFactory: ViewControllerFactory {
    let questions: [Question<String>]
    let options: [Question<String>: [String]]
    let correctAnswers: [Question<String>: [String]]

    init(questions: [Question<String>],
         options: [Question<String>: [String]],
         correctAnswers: [Question<String>: [String]]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        return makeQuestionVC(question: question, options: options, answerCallback: answerCallback)
    }
    
    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let controller = ResultVC(summary: presenter.summary, answers: presenter.presentableAnswers)
        controller.title = presenter.title
        return controller
    }
    
    private func makeQuestionVC(question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> QuestionVC {
        switch question {
        case .singleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: false, answerCallback: answerCallback)
        case .multipleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: true, answerCallback: answerCallback)
        }
    }
    
    private func questionViewController(for question: Question<String>, value: String, options: [String],
                                        allowsMultipleSelection: Bool, answerCallback: @escaping ([String]) -> Void) -> QuestionVC {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let vc = QuestionVC(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
        vc.title = presenter.title
        return vc
    }
}
