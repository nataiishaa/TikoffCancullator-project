//
//  HistoryTableViewCell.swift
//  TinkoffCalculator
//
//  Created by Vitali on 26/01/2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell{
    
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var expressionLabel: UILabel!
    
    
    func configure(with expression: String, result: String){
        resultLabel.text = result
        expressionLabel.text = expression
    }

}
