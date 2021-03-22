//
//  DiagramView.swift
//  MobDevLab1
//
//  Created by Dima on 15.02.2021.
//

import UIKit

class DiagramView: UIView {

    override func draw(_ rect: CGRect) {
        let arr = [(value: 0.1, color: UIColor.yellow),
                   (value: 0.2, color: UIColor.green),
                   (value: 0.25, color: UIColor.blue),
                   (value: 0.05, color: UIColor.red),
                   (value: 0.4, color: UIColor.cyan)]
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        var currAngle:CGFloat = 0

        for i in arr {
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: bounds.width/2.5, startAngle: currAngle, endAngle: currAngle + (CGFloat.pi * 2 * CGFloat(i.value)), clockwise: true)
            currAngle = currAngle + (CGFloat.pi * 2 * CGFloat(i.value))
            path.close()
            let color = i.color
            color.setFill()
            path.fill()
        }
        let path2 = UIBezierPath()
        path2.addArc(withCenter: center, radius: bounds.width/5, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        let color = UIColor.white
        color.setFill()
        path2.fill()
        
    }

}
