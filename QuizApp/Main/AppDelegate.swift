//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Shohin Tagaev on 12/15/20.
//

import UIKit
import QuizEngine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var game: Game<Question<String>, [String], NavigationControllerRouter>?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let question1 = Question<String>.singleAnswer("What is capital of Uzbekistan?")
        let question2 = Question<String>.multipleAnswer("Select countries in Central Asia.")
        let questions = [question1, question2]
        
        let option1 = "Dushanbe"
        let option2 = "Ashxobod"
        let option3 = "Tashkent"
        
        let option4 = "Uzbekistan"
        let option5 = "Russia"
        let option6 = "China"
        let option7 = "Tadjikistan"
        let option8 = "Kirgizistan"
        
        let options = [question1: [option1, option2, option3], question2: [option4, option5, option6, option7, option8]]
        
        let correctAnswers = [question1: [option3], question2: [option4, option7, option8]]
        
        let navigationController = UINavigationController()
        
        let factory = iOSViewControllerFactory(questions: questions, options: options, correctAnswers: correctAnswers)
        
        let router = NavigationControllerRouter(navigationController, factory: factory)
        
        
        game = startGame(questions: questions, router: router, correctAnswers: correctAnswers)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
        
        return true
    }
}

