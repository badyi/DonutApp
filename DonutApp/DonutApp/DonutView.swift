//
//  DonutView.swift
//  DonutApp
//
//  Created by badyi on 14.05.2021.
//

import UIKit

final class DonutView: UIView {
    private var outterRadius: CGFloat
    private var innerRadius: CGFloat
    private var a: CGFloat
    private var b: CGFloat
    
    convenience init(innerRadius: CGFloat, color: UIColor) {
        self.init(frame: .zero)
        self.innerRadius = innerRadius
        backgroundColor = color
    }
    
    override init(frame: CGRect) {
        self.innerRadius = 0
        self.outterRadius = 0
        self.a = 0
        self.b = 0
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if bounds.width != bounds.height {
            fatalError("donut shoud have width == height")
        }
        outterRadius = bounds.size.height / 2
        a = bounds.width / 2
        b = bounds.height / 2
        
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: innerRadius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(CGRect(origin: .zero, size: frame.size))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        layer.mask = maskLayer
        layer.cornerRadius = outterRadius
        clipsToBounds = true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isHidden else { return nil }
        guard isUserInteractionEnabled else { return nil }
        guard isDonutTouched(point) else { return nil }
        
        return super.hitTest(point, with: event)
    }
}

extension DonutView {
    private func isDonutTouched(_ point: CGPoint) -> Bool {
        let f = circleFunc(x: point.x, y: point.y)
        guard f < outterRadius * outterRadius else {
            print("outside of big circle")
            return false
        }
        guard f > innerRadius * innerRadius else {
            print("inside little circle")
            return false
        }
        print("inside donut")
        return true
    }
    
    private func circleFunc(x: CGFloat, y: CGFloat) -> CGFloat {
        let calcX = (x - a) * (x - a)
        let calcY = (y - b) * (y - b)
        let calc = calcX + calcY
        
        return calc
    }
}
