//
//  AnimUtils.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 8. 22..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit

class AnimUtils: NSObject, UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScrollingAnim(tabBarController: tabBarController)
    }
    
}

class ScrollingAnim: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    var tabBarController: UITabBarController?
    var fromIndex = 0
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.fromIndex = tabBarController.selectedIndex
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 뷰 만들어주기
        self.transitionContext = transitionContext
        let containView = transitionContext.containerView
        
        // 원래 뷰
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        // 추가될 뷰
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        containView.addSubview(toView!.view)
        
        var width = toView!.view.bounds.width
        
        if tabBarController!.selectedIndex < fromIndex {
            width = -width
        }
        
        toView!.view.transform = CGAffineTransform(translationX: width, y: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: (self.transitionContext)), animations: {
            // 입력되는 뷰
            toView!.view.transform = CGAffineTransform.identity
            fromView!.view.transform = CGAffineTransform(translationX: -width, y: 0)
        }, completion: { _ in
            // 사라지는 뷰
            fromView!.view.transform = CGAffineTransform.identity
            self.transitionContext!.completeTransition(!self.transitionContext!.transitionWasCancelled)
        })
        
        
    }
    
}
