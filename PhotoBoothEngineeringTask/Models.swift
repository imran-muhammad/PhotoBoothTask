//
//  Models.swift
//  PhotoBoothEngineeringTask
//
//  Created by Imran Muhammad on 11/22/22.
//

import Foundation

struct Cat: Decodable {
    let _id: String
    let tags: [String]
    let owner: String
    let createdAt: String
    let updatedAt: String
    var urlString: String?
}

class Filter { //This is a class instead of struct because we want it to be passed by reference
    
    let filterText: String
    var isSelected: Bool
    
    init(filterText: String, isSelected: Bool) {
        self.filterText = filterText
        self.isSelected = isSelected
    }
}

