//
//  Question.swift
//  QuizApp
//
//  Created by Shohin Tagaev on 23/12/20.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
}
