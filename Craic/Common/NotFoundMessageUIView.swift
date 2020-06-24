//
//  NotFoundMessageUIView.swift
//  Craic
//
//  Created by Denis Fortuna on 23/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class NotFoundMessageUIView: UIView {

    let containerView = UIView()
    let woopsImageView = UIImageView()
    let woopsMessageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

        configureContainerView()
        configureWoopsImageView()
        configureMessageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContainerView() {
        self.addSubview(containerView)
//        containerView.backgroundColor = .green
        containerView.anchorCenters(centerX: self.centerXAnchor,
                                    centerY: self.centerYAnchor)
        containerView.anchorSizes(sizeWidth: 300, sizeHeight: 300)
    }
    
    func configureWoopsImageView() {
        containerView.addSubview(woopsImageView)
        woopsImageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "Woops")
        let template = image.withRenderingMode(.alwaysTemplate)
        woopsImageView.image = template
        woopsImageView.tintColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        woopsImageView.anchorEdges(top: containerView.topAnchor,
                                   left: containerView.leftAnchor,
                                   right: containerView.rightAnchor,
                                   bottom: nil, padding: .zero)
        woopsImageView.anchorSizes(sizeWidth: nil, sizeHeight: 100)
        
    }
    
    func configureMessageView() {
        containerView.addSubview(woopsMessageLabel)
        let message = """
Woops!
Nothing to show here..
"""
        woopsMessageLabel.text = message
        woopsMessageLabel.textColor = .darkGray
        woopsMessageLabel.textAlignment = .center
        woopsMessageLabel.numberOfLines = 0
        
        woopsMessageLabel.anchorEdges(top: woopsImageView.bottomAnchor,
                                      left: woopsImageView.leftAnchor,
                                      right: woopsImageView.rightAnchor,
                                      bottom: nil,
                                      padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }

}
