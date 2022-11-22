//
//  FilterTableViewCell.swift
//  PhotoBoothEngineeringTask
//
//  Created by Imran Muhammad on 11/21/22.
//

import Foundation
import UIKit

class FilterTableViewCell: UITableViewCell {
    
    var filter: Filter?
    
    func configureWith(filter: Filter) {
        self.filter = filter
        self.textLabel?.text = filter.filterText
    }
    
    func didTapCell() {
        self.filter?.isSelected = self.isSelected
    }
}
