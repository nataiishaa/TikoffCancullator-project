//
//  CalculationListController.swift
//  TinkoffCalculator
//
//  Created by Vitali on 26/01/2024.
//

import UIKit

class CalculationListController: UIViewController{
    
   // var result: String?
    var calculation:[(expression: [CalculationHistoryItem], result: Double)] = []
 //   @IBOutlet weak var calculationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  calculationLabel.text = result
       
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Прошлые вычисления"
      
        
    }
    
    private func initialize(){
        modalPresentationStyle = .fullScreen   
    }
    @IBAction func dismissVC(_ sender: UIButton) {
      //  dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    private func expressionToString(_ expression:[CalculationHistoryItem]) -> String{
         var result = ""
        
        for operand in  expression{
            switch operand {
            case let .number(value):
                result += String(value) + " "
            case let .operation(value):
                result += value.rawValue + " "
            }
        }
        
        return result
    }
}

 
extension CalculationListController:  UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {return UITableViewCell()}
        
        let historyItem = calculation[indexPath.row]
        
        cell.configure(with: expressionToString(historyItem.expression), result: String(historyItem.result))
        return cell
    }
    
 
}

extension CalculationListController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let getDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: getDate)
    }
}
