//
//  TabBarControl.swift
//  Weather
//
//  Created by Tim Pyshnov on 03.07.2021.
//

import UIKit

final class TabBarControl: UIControl {

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .center
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var imageView = UIImageView()

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = bounds
    }

}
