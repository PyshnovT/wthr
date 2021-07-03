//
//  CellSizing.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import UIKit

protocol CellSizing {
    static func height(for item: Any, width: CGFloat) -> CGFloat
}

