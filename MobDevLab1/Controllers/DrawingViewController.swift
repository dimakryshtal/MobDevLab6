//
//  DrawingViewController.swift
//  MobDevLab1
//
//  Created by Dima on 11.02.2021.
//

import UIKit

class DrawingViewController: UIViewController {

    lazy var width = self.view.safeAreaLayoutGuide.layoutFrame.width
    lazy var height = self.view.safeAreaLayoutGuide.layoutFrame.height
    
    lazy var ipadConstraints: [NSLayoutConstraint] = [
        f.widthAnchor.constraint(equalToConstant: (width < height ? width - 110 : height - 110)),
        f.heightAnchor.constraint(equalToConstant: (width < height ? width - 110 : height - 110)),
        f.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        f.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 10)
    ]
    
    var f:UIView = {
        let f = UIView()
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    lazy var portraitConstraints:[NSLayoutConstraint] = [
        f.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        f.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        f.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
        f.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
        
  
    ]
    lazy var landscapceConstraint:[NSLayoutConstraint] = [
        f.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        f.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        f.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -40 ),
        f.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -40)
    ]
    
    lazy var segContConstaints: [NSLayoutConstraint] = [
        segmentedControl.bottomAnchor.constraint(equalTo: f.topAnchor, constant: -5),
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        segmentedControl.widthAnchor.constraint(equalToConstant: 160),
        segmentedControl.heightAnchor.constraint(equalToConstant: 25)
    ]
    
    
    let graph: GraphView = {
        let graph = GraphView()
        //graph.clipsToBounds = true
        graph.backgroundColor = .clear
        
        return graph
    }()
    let diagram: DiagramView = {
        let diagram = DiagramView()
        diagram.backgroundColor = .clear
        return diagram
    }()
     
    private let segmentedControl: UISegmentedControl = {
        let segContr = UISegmentedControl(items: ["Graph", "Diagram"])
        let font = UIFont.systemFont(ofSize: 15)
        segContr.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segContr.translatesAutoresizingMaskIntoConstraints = false
        segContr.addTarget(self, action: #selector(segDidChange(_:)), for: .valueChanged)
        return segContr
    }()
    
    @objc func segDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            diagram.removeFromSuperview()
            f.addSubview(graph)
        case 1:
            graph.removeFromSuperview()
            f.addSubview(diagram)
        default:
            break
        }
    }
    override func viewDidLayoutSubviews() {
        graph.frame = f.bounds
        diagram.frame = f.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(segmentedControl)
        view.addSubview(f)
        
        
        NSLayoutConstraint.activate(segContConstaints)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate(ipadConstraints)
        } else {
            if traitCollection.verticalSizeClass == .compact {
                NSLayoutConstraint.activate(landscapceConstraint)
            } else {
                NSLayoutConstraint.activate(portraitConstraints)
            }
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            NSLayoutConstraint.deactivate(portraitConstraints)
            f.setNeedsDisplay()
            NSLayoutConstraint.activate(landscapceConstraint)
        } else{
            NSLayoutConstraint.deactivate(landscapceConstraint)
            f.setNeedsDisplay()
            NSLayoutConstraint.activate(portraitConstraints)
        }
    }

}
