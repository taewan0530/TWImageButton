//
//  TWImageButton.swift
//  TWImageButtonDemo
//
//  Created by kimtaewan on 2016. 1. 4..
//  Copyright © 2016년 prnd. All rights reserved.
//

import UIKit

@IBDesignable
public class TWImageButton: UIButton {
    
    private let highlightedAlpha: CGFloat = 0.2
    
    private var _beforeImageView: UIImageView?
    private var _afterImageView: UIImageView?
    
    private var beforeImageRect = CGRectZero
    private var afterImageRect = CGRectZero
    
    override public var highlighted: Bool {
        willSet {
            if newValue == highlighted { return }
            if self.buttonType == .System {
                let alpha = newValue ? highlightedAlpha : 1
                UIView.animateWithDuration(newValue ? 0.1 : 0.3, animations: { () -> Void in
                    self._beforeImageView?.alpha = alpha
                    self._afterImageView?.alpha = alpha
                })
            }
        }
    }
    
    @IBInspectable public var vertical: Bool = false  { didSet { self.layoutImages() } }
    
    @IBInspectable public var beforeImage: UIImage? {
        didSet{
            guard let beforeImage = beforeImage else {
                self.resetImageView(_beforeImageView)
                return
            }
            if _beforeImageView == nil { _beforeImageView = UIImageView() }
            self.imageLayout(_beforeImageView!,image: beforeImage)
            beforeImageRect = _beforeImageView!.bounds
            self.addSubview(_beforeImageView!)
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var afterImage: UIImage? {
        didSet{
            guard let afterImage = afterImage else {
                self.resetImageView(_afterImageView)
                return
            }
            if _afterImageView == nil { _afterImageView = UIImageView() }
            self.imageLayout(_afterImageView!, image: afterImage)
            afterImageRect = _afterImageView!.bounds
            self.addSubview(_afterImageView!)
            self.layoutIfNeeded()
        }
    }
    
    @IBInspectable public var beforeSpacing: CGFloat = 0 { didSet { self.layoutImages() } }
    @IBInspectable public var afterSpacing: CGFloat = 0 { didSet { self.layoutImages() } }
    
}

// MARK - layout
extension TWImageButton {
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layoutImages()
    }
    
    override public func intrinsicContentSize() -> CGSize {
        var size = CGSizeZero
        
        if let _ = self.titleLabel?.text, _ = self.imageView?.image {
            size = self.sizeThatFits(self.bounds.size)
        } else if let _ = self.titleLabel?.text {
            size = self.titleLabel!.sizeThatFits(self.bounds.size)
        } else if let image = self.imageView?.image {
            size = image.size
        }
        
        if vertical {
            size.height += beforeImageRect.height + afterImageRect.height + beforeSpacing + afterSpacing
            size.width = max(size.width, max(beforeImageRect.width, afterImageRect.width))
        } else {
            size.width += beforeImageRect.width + afterImageRect.width + beforeSpacing + afterSpacing
            size.height = max(size.height, max(beforeImageRect.height, afterImageRect.height))
        }
        return size
    }
    
    private func layoutImages(){
        let contentRect = contentFrame()
        
        if vertical {
            self.contentEdgeInsets = UIEdgeInsetsMake(beforeImageRect.size.height - afterImageRect.size.height + (beforeSpacing - afterSpacing), 0, 0, 0)
        } else {
            self.contentEdgeInsets = UIEdgeInsetsMake(0, beforeImageRect.size.width - afterImageRect.size.width + (beforeSpacing - afterSpacing), 0, 0)
        }
        
        if let beforeImageView = _beforeImageView {
            var point = contentRect.origin
            
            if vertical {
                point.x += (contentRect.size.width - beforeImageRect.size.width)/2
                point.y -= beforeImageRect.size.height + beforeSpacing
            } else {
                point.x -= beforeImageRect.width + beforeSpacing
                point.y += (contentRect.size.height - beforeImageRect.size.height)/2
            }
            beforeImageView.frame.origin = point
        }
        
        if let afterImageView = _afterImageView {
            var point = contentRect.origin
            if vertical {
                point.x += (contentRect.size.width - afterImageRect.size.width)/2
                point.y += contentRect.size.height + afterSpacing
            } else {
                point.x += contentRect.size.width + afterSpacing
                point.y += (contentRect.size.height - afterImageRect.size.height)/2
            }
            afterImageView.frame.origin = point
        }
    }
    
    private func contentFrame() -> CGRect {
        let centerPoint = CGPointMake(self.bounds.width/2, self.bounds.height/2)
        let imageViewRect = self.imageView?.bounds ?? CGRectZero
        let titleLabelRect = self.titleLabel?.bounds ?? CGRectZero
        
        let w = imageViewRect.width + titleLabelRect.width
        let h = max(imageViewRect.height, titleLabelRect.height)
        
        var x = centerPoint.x - (imageViewRect.width + titleLabelRect.width)/2
        var y = centerPoint.y - h/2
        
        x += vertical ? 0 : (beforeImageRect.width - afterImageRect.width)/2 + (beforeSpacing - afterSpacing)/2
        y += vertical ? (beforeImageRect.height - afterImageRect.height)/2 + (beforeSpacing - afterSpacing)/2 : 0
        
        return CGRectMake(x, y, w, h)
    }
    
    private func imageLayout(imageView: UIImageView, image: UIImage){
        imageView.image = image
        imageView.bounds.size = image.size
    }
    
    private func resetImageView(imageView: UIImageView?){
        guard let imageView = imageView else { return }
        if imageView == _beforeImageView {
            beforeImageRect = CGRectZero
        } else if imageView == _afterImageView {
            afterImageRect = CGRectZero
        }
        imageView.removeFromSuperview()
        self.layoutIfNeeded()
    }
    
}

//extension TWImageButton {
//
//    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesBegan(touches, withEvent: event)
//        print(self.titleLabel?.alpha)
//    }
//
//    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesEnded(touches, withEvent: event)
//        print(self.titleLabel?.alpha)
//    }
//}
