//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Nataly on 25/01/2024.
//

import UIKit

enum CalculateError: Error{
    case dividedByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiplay = "x"
    case divide = "/"
    
    
    func calculate(numberOne: Double, numberTwo: Double) throws -> Double{
        switch self {
        case .add: return numberOne + numberTwo
        case .substract: return numberOne - numberTwo
        case .multiplay: return numberOne * numberTwo
        case .divide: if numberTwo == 0 {
            throw CalculateError.dividedByZero
        }
            return numberOne / numberTwo
        }
    }
}

enum CalculationHistoryItem{
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {

    
    var calculationHistory:[CalculationHistoryItem] = []
    var calculation:[(expression: [CalculationHistoryItem], result: Double)] = []

    
    var checkCalculation: Bool = false
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru-RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var historyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetLabel()
        historyButton.accessibilityIdentifier = "historyButton"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
  
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else {return}
      //  print(buttonText)
            
        if buttonText == "," && textLabel.text?.contains(",") == true{
            return
        }
        if textLabel.text == "Нельзя делить на ноль"{
            resetLabel()
        }
        
        if textLabel.text == "0"{
            textLabel.text = buttonText
        }else{
            textLabel.text?.append(buttonText)
        }
    }
    
    @IBAction func showCalculationLIst(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationListVC = sb.instantiateViewController(identifier: "CalculationListController")
        if let vc = calculationListVC as? CalculationListController{
            if checkCalculation{
                vc.calculation = calculation
            }else{
              //  vc.result = "NoData"
            }
        
        }
        
      //  show(calculationListVC, sender: self)
        
        navigationController?.pushViewController(calculationListVC, animated: true)
    }
    
    
//    @IBAction func unwindAction(unwindSeque: UIStoryboardSegue){
//        
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "calculationList",
//              let calculationListVC = segue.destination as? CalculationListController
//        else {return}
//
//        calculationListVC.result = textLabel.text
//    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else {return}
        
        guard let labelText = textLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else{return}
      
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLabel()
    }
    
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        calculationHistory.removeAll()
        resetLabel()
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        guard let labelText = textLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else{return}
      
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            textLabel.text = numberFormatter.string(from: NSNumber(value: result))
            calculation.append((calculationHistory, result))
            checkCalculation = true
        }catch {
            textLabel.text = "Нельзя делить на ноль"
            checkCalculation = false
        }
        
        calculationHistory.removeAll()
    }
    

    
    func resetLabel(){
        textLabel.text = "0"
        checkCalculation = false
    }
    
    
    func calculate() throws ->  Double{
        guard case .number(let firstNumber) = calculationHistory[0] else {return 0}
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2){
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
            else{break}
            
            currentResult = try operation.calculate(numberOne: currentResult, numberTwo: number)
        }
        
        return currentResult
    }
}

