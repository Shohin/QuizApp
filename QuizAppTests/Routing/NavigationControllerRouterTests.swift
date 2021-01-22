//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Shohin Tagaev on 12/21/20.
//

import XCTest
import QuizEngine
@testable import QuizApp

final class NavigationControllerRouterTests: XCTestCase {
    private let singleAnswerQuestion =  Question.singleAnswer("Q1")
    private let multipleAnswerQuestion =  Question.multipleAnswer("Q2")
    
    let navigationController = NotAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut = NavigationControllerRouter(navigationController, factory: factory)

    func test_answerForQuestion_showsQuestionController() {
        let vc = UIViewController()
        let secondVC = UIViewController()
        factory.stub(qeustion: singleAnswerQuestion, with: vc)
        factory.stub(qeustion: Question.singleAnswer("Q2"), with: secondVC)
        
        sut.answer(for: singleAnswerQuestion, completion: {_ in})
        sut.answer(for: Question.singleAnswer("Q2"), completion: {_ in})

        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, vc)
        XCTAssertEqual(navigationController.viewControllers.last, secondVC)
    }
    
    func test_answerForQuestion_singleAnswer_answerCallbackProgressToNextQuestion() {
        var callbackWasFired = false
        
        sut.answer(for: singleAnswerQuestion, completion: {_ in callbackWasFired = true})
        
        factory.answerCallBacks[singleAnswerQuestion]!(["anything"])
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_answerForQuestion_singleAnswer_doesNotConfigureViewControllerWithSubmitButton() {
        let vc = UIViewController()
        factory.stub(qeustion: singleAnswerQuestion, with: vc)

        sut.answer(for: singleAnswerQuestion, completion: {_ in })
                
        XCTAssertNil(vc.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswer_answerCallbackDoesNotProgressToNextQuestion() {
        var callbackWasFired = false
        
        sut.answer(for: multipleAnswerQuestion, completion: {_ in callbackWasFired = true})
        
        factory.answerCallBacks[multipleAnswerQuestion]!(["anything"])
        
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_answerForQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let vc = UIViewController()
        factory.stub(qeustion: multipleAnswerQuestion, with: vc)

        sut.answer(for: multipleAnswerQuestion, completion: {_ in })
                
        XCTAssertNotNil(vc.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswersSelected() {
        let vc = UIViewController()
        factory.stub(qeustion: multipleAnswerQuestion, with: vc)

        sut.answer(for: multipleAnswerQuestion, completion: {_ in })
        XCTAssertFalse(vc.navigationItem.rightBarButtonItem!.isEnabled)

        factory.answerCallBacks[multipleAnswerQuestion]!(["A1"])
        XCTAssertTrue(vc.navigationItem.rightBarButtonItem!.isEnabled)
                
        factory.answerCallBacks[multipleAnswerQuestion]!([])
        XCTAssertFalse(vc.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_progressToNextQuestion() {
        let vc = UIViewController()
        factory.stub(qeustion: multipleAnswerQuestion, with: vc)

        var callbackWasFired = false

        sut.answer(for: multipleAnswerQuestion, completion: {_ in
            callbackWasFired = true
        })

        factory.answerCallBacks[multipleAnswerQuestion]!(["A1"])
        
        let button = vc.navigationItem.rightBarButtonItem!
        button.simulateTap()
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showsResultController() {
        let vc = UIViewController()
        let secondVC = UIViewController()
        
        let result = Result.make(answers: [singleAnswerQuestion: ["A1"]], score: 10)
        let secondResult = Result.make(answers: [Question.singleAnswer("Q2"): ["A2"]], score: 20)
        
        factory.stub(result: result, with: vc)
        factory.stub(result: secondResult, with: secondVC)

        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, vc)
        XCTAssertEqual(navigationController.viewControllers.last, secondVC)
    }
}

final class NotAnimatedNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}

final class ViewControllerFactoryStub: ViewControllerFactory {
    private var stubbedQuestions = [Question<String>: UIViewController]()
    private var stubbedResults = Dictionary<Result<Question<String>, [String]>, UIViewController>()

    var answerCallBacks = [Question<String>: ([String]) -> Void]()
    
    func stub(qeustion: Question<String>, with vc: UIViewController) {
        stubbedQuestions[qeustion] = vc
    }
    
    func stub(result: Result<Question<String>, [String]>, with vc: UIViewController) {
        stubbedResults[result] = vc
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        answerCallBacks[question] = answerCallback
        return stubbedQuestions[question] ?? UIViewController()
    }
    
    func resultsViewController(for userAnswers: Answers) -> UIViewController {
        UIViewController()
    }
    
    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        stubbedResults[result] ?? UIViewController()
    }
}

private extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)

    }
}
