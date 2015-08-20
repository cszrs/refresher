//
//  AutoToNextView.swift
//  RefresherDemo
//
//  Created by 云之彼端 on 15/8/20.
//  Copyright (c) 2015年 cezr. All rights reserved.
//

import UIKit

private var KVOContext = "RefresherKVOContext"
private let ContentOffsetKeyPath = "contentOffset"

public protocol AutoToNextViewDelegate {
    func autoToNextStart(view: AutoToNextView)
}

public class AutoToNextView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    private var scrollViewBouncesDefaultValue: Bool = false
    private var scrollViewInsetsDefaultValue: UIEdgeInsets = UIEdgeInsetsZero
    
    private var previousOffset: CGFloat = 0
    
//    var delegate : AutoToNextViewDelegate?
    
    private var action: (() -> ()) = {}
    
    
    internal var next: Bool = false {
        
        didSet {
            if next {
                startLoading()
            } else {
                
            }
        }
    }
    
    init(frame: CGRect, action :(() -> ())) {
        self.action = action
        super.init(frame: frame)
        self.autoresizingMask = .FlexibleWidth
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UIView methods
    
    override public func willMoveToSuperview(newSuperview: UIView!) {
        superview?.removeObserver(self, forKeyPath: ContentOffsetKeyPath, context: &KVOContext)
        if let scrollView = newSuperview as? UIScrollView {
            scrollView.addObserver(self, forKeyPath: ContentOffsetKeyPath, options: .Initial, context: &KVOContext)
            scrollViewBouncesDefaultValue = scrollView.bounces
            scrollViewInsetsDefaultValue = scrollView.contentInset
        }
    }
    
    deinit {
        var scrollView = superview as? UIScrollView
        scrollView?.removeObserver(self, forKeyPath: ContentOffsetKeyPath, context: &KVOContext)
    }
    
    
    
    
    //MARK: KVO methods
    
    override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if (context == &KVOContext) {
            if let scrollView = superview as? UIScrollView where object as? NSObject == scrollView {
                
                if !next {
                    if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height*0.8 {
                        next = true
                    }
                }
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    
    func startLoading() {
        action()
    }
    
    func endLoading() {
        next = false
    }
    
}
