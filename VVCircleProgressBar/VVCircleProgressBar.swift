//
//  VVCircleProgressBar.swift
//  VVCircleProgressBar
//
//  Created by Vinoth Vino on 23/06/18.
//  Copyright © 2018 Vinoth Vino. All rights reserved.
//

import UIKit

class VVCircleProgressBar: UIView {
    
    //MARK: - PROPERTIES
    
    /// Text Color of the progress label
    open var textColor: UIColor = UIColor.white {
        didSet {
            progressLabel.textColor = textColor
        }
    }
    /// Set the font for the progress label
    open var font: UIFont = UIFont.boldSystemFont(ofSize: 32) {
        didSet {
            progressLabel.font = font
        }
    }
    /// Set the text alignment for the progress label
    open var textAlignment: NSTextAlignment = NSTextAlignment.center {
        didSet {
            progressLabel.textAlignment = textAlignment
        }
    }
    /// Set pulsing color for the pulsing layer
    open var pulsingColor: UIColor = UIColor.pulsatingFillColor {
        didSet {
            pulsingLayer.fillColor = pulsingColor.cgColor
        }
    }
    /// Set stroke color for the tracking layer
    open var trackingStrokeColor: UIColor = UIColor.trackStrokeColor {
        didSet {
            trackLayer.strokeColor = trackingStrokeColor.cgColor
        }
    }
    /// Set fill color for the tracking layer
    open var trackingFillColor: UIColor = UIColor.backgroundColor {
        didSet {
            trackLayer.fillColor = trackingFillColor.cgColor
        }
    }
    /// Set the progress color
    open var progressColor: UIColor = UIColor.outlineStrokeColor {
        didSet {
            shapeLayer.strokeColor = progressColor.cgColor
        }
    }
    /// Set the width of the progress layer
    open var progressLayerWidth: CGFloat = 20 {
        didSet {
            shapeLayer.lineWidth = progressLayerWidth
        }
    }
    /// Set the width of the track layer
    open var trackLayerWidth: CGFloat = 20 {
        didSet {
            trackLayer.lineWidth = trackLayerWidth
        }
    }
    /// Set the width of the pulse layer
    open var pulseLayerWidth: CGFloat = 1.3 {
        didSet {
            animation.toValue = pulseLayerWidth
            pulsingLayer.add(animation, forKey: "Pulsing")
        }
    }
    
    var pulsingLayer: CAShapeLayer!
    var shapeLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var animation: CABasicAnimation!

    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0 %"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //MARK: - Pulsing Layer
        pulsingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: pulsingColor)
        self.layer.addSublayer(pulsingLayer)
        startPulsingAnimation()
        
        //MARK: - Track Layer
        trackLayer = createCircleShapeLayer(strokeColor: trackingStrokeColor, fillColor: trackingFillColor)
        self.layer.addSublayer(trackLayer)
        
        //MARK: - Shape Layer
        shapeLayer = createCircleShapeLayer(strokeColor: progressColor, fillColor: .clear)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        self.layer.addSublayer(shapeLayer)
        setupProgressLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Start the pulsing animation
    func startPulsingAnimation() {
        animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.repeatCount = Float.infinity
        pulsingLayer.add(animation, forKey: "Pulsing")
    }
    
    /// Stop the pulsing animation
    func stopPulsingAnimation() {
        pulsingLayer.lineWidth = 0
        pulsingLayer.removeAnimation(forKey: "Pulsing")
    }
    
    //MARK: - Create Circle Shape Layer
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = kCALineCapRound
        layer.position = self.center
        return layer
    }
    
    private func setupProgressLabel() {
        self.addSubview(progressLabel)
        progressLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        progressLabel.center = self.center
    }
    
}
