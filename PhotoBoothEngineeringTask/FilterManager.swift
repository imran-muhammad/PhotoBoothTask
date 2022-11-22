//
//  FilterManager.swift
//  PhotoBoothEngineeringTask
//
//  Created by Imran Muhammad on 11/22/22.
//

import Foundation

class FilterManager {
    
    var allCats: [Cat] = []
    var filteredCats: [Cat] = []
    var allTagLabels: [String] = []
    var allFilters: [Filter] = []
    
    init(cats: [Cat]) {
        self.allCats = cats
        self.extractFilters()
    }
    
    var filtersApplied: Bool {
        return self.filteredCats.count > 0
    }
    
    func extractFilters() {
        for cat in self.allCats {
            for tagLabel in cat.tags {
                if !self.allTagLabels.contains(tagLabel) {
                    self.allTagLabels.append(tagLabel)
                    let filter = Filter(filterText: tagLabel, isSelected: false)
                    self.allFilters.append(filter)
                }
            }
        }
    }
    
    func updateFilter(filter: Filter, index: Int) {
        self.allFilters[index] = filter
    }
    
    func clearAllFilters() {
        self.filteredCats = []
        for filter in allFilters where filter.isSelected == true {
            filter.isSelected = false
        }
    }
    
    func didTapDoneButton() {
        self.filteredCats = []
        let appliedFilters = self.allFilters.filter { filter in
            return filter.isSelected == true
        }
        for appliedfilter in appliedFilters {
            self.filteredCats = self.allCats.filter { cat in
                return cat.tags.contains(appliedfilter.filterText)
            }
        }
    }
    
    
}
