//
//  ViewController.swift
//  Delegate practice
//
//  Created by POYEH on 2020/1/13.
//  Copyright © 2020 POYEH. All rights reserved.
//

import UIKit

enum ButtonSet: String {
    case yellow = "Yellow"
    case red = "Red"
    case blue = "Blue"
    
    func color() -> UIColor {
        switch self {
            case .yellow: return .yellow
            case .red: return .red
            case .blue: return .blue
        }
    }
    
}



class ViewController: UIViewController {
    
    let tableview = UITableView()
    let topSet: [ButtonSet] = [.red, .yellow]
    let bottomSet: [ButtonSet] = [.red, .yellow, .blue]
    @IBOutlet weak var topSelectionView: SelectionView!
    @IBOutlet weak var bottomSelectionView: SelectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topSelectionView.delegate = self
        topSelectionView.dataSource = self
        bottomSelectionView.delegate = self
        bottomSelectionView.dataSource = self
        topView.backgroundColor = topSet.first?.color()
        bottomView.backgroundColor = bottomSet.first?.color()
    }
    


}

extension ViewController: SelectionViewDataSource, SelectionViewDelegate  {
    
    func barItemTitles(_ view: SelectionView, index: Int) -> String {
        if view == topSelectionView {
            return topSet[index].rawValue
        } else {
            return bottomSet[index].rawValue
        }
    }
    
    
    func numberOfBtns(_ view: SelectionView) -> Int {
        if view == topSelectionView {
            return topSet.count
        } else {
            return bottomSet.count
        }
    }
    
    func IndicatorColor(_ view: SelectionView) -> UIColor {
        return .blue
    }
    
    func didSelectItem(_ view: SelectionView, didSelectedItemAt index: Int) {
        if view == topSelectionView {
            
            topView.backgroundColor = topSet[index].color()
            
        } else {
            
            bottomView.backgroundColor = bottomSet[index].color()
            
        }
    }
    
    func canSelectItem(_ view: SelectionView, didSelectedItemAt index: Int) -> Bool {
        if view == topSelectionView {
            
            return true
            
        } else {
            
            if topSelectionView.selectedIndex == topSet.count - 1 {
                
                return false
                
            } else {
                
                return true
                
            }
            
        }
        
    }
    
    
    
}








