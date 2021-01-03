//
//  QuestionPresenter.swift
//  
//
//  Created by Shohin Tagaev on 27/12/20.
//

import Foundation
import QuizEngine

struct QuestionPresenter {
    let questions: [Question<String>]
    let question: Question<String>
    
    var title: String {
        guard let index = questions.firstIndex(of: question) else {
            return ""
        }
        return "Question #\(index + 1)"
    }
}
