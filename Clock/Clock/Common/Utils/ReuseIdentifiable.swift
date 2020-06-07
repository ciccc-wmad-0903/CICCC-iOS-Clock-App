//
//  ReuseIdentifiable.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-06.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

protocol ReuseIdentifiable: class {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String { .init(describing: self) }
}

extension UITableViewCell: ReuseIdentifiable {}
