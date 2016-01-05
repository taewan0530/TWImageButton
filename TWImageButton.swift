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
    private var _beforeImageView: UIImageView?
    private var _afterImageView: UIImageView?
    
    private var beforeImageRect = CGRectZero
    private var afterImageRect = CGRectZero
    
    @IBInspectable var vertical: Bool = false
    
    @IBInspectable var beforeImage: UIImage? {
        didSet{
            guard let beforeImage = beforeImage else { return }
            if _beforeImageView == nil {
                _beforeImageView = UIImageView()
            }
            guard let beforeImageView = _beforeImageView else { return }
            beforeImageView.alpha = 0.4
            self.imageLayout(beforeImageView,image: beforeImage)
            beforeImageRect = beforeImageView.bounds
            self.addSubview(beforeImageView)
        }
    }
    
    @IBInspectable var afterImage: UIImage? {
        didSet{
            guard let afterImage = afterImage else { return }
            if _afterImageView == nil {
                _afterImageView = UIImageView()
            }
            guard let afterImageView = _afterImageView else { return }
            afterImageView.alpha = 0.4
            self.imageLayout(afterImageView, image: afterImage)
            afterImageRect = afterImageView.bounds
            self.addSubview(afterImageView)
        }
    }
    
    @IBInspectable var beforeSpacing: CGFloat = 0
    @IBInspectable var afterSpacing: CGFloat = 0
}

// MARK - layout
extension TWImageButton {
    private func imageLayout(imageView: UIImageView, image: UIImage){
        imageView.image = image
        imageView.bounds.size = image.size
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let contentRect = contentFrame()
        
        let tx: CGFloat = vertical ? 0 : (beforeImageRect.width - afterImageRect.width)/2 + (beforeSpacing - afterSpacing)/2
        let ty: CGFloat =  vertical ? (beforeImageRect.height - afterImageRect.height)/2 + (beforeSpacing - afterSpacing)/2 : 0
        contentOffset(x: tx, y: ty)
        
        if let beforeImageView = _beforeImageView {
            var point = contentRect.origin
            point.x += tx
            point.y += ty
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
            point.x += tx
            point.y += ty
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
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
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
    
    private func contentFrame() -> CGRect {
        let centerPoint = CGPointMake(self.bounds.width/2, self.bounds.height/2)
        let imageViewRect = self.imageView?.bounds ?? CGRectZero
        let titleLabelRect = self.titleLabel?.bounds ?? CGRectZero
        
        let w = imageViewRect.width + titleLabelRect.width
        let h = max(imageViewRect.height, titleLabelRect.height)
        
        let x = centerPoint.x - (imageViewRect.width + titleLabelRect.width)/2
        let y = centerPoint.y - h/2
        
        return CGRectMake(x, y, w, h)
    }
    
    private func contentOffset(x x: CGFloat, y: CGFloat){
        if let imageView = self.imageView {
            imageView.transform = CGAffineTransformMakeTranslation(x, y)
        }
        if let titleLabel = self.titleLabel {
            titleLabel.transform = CGAffineTransformMakeTranslation(x, y)
        }
    }
    
}
