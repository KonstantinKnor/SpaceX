//
//  SettingsViewController.swift
//  SpaceX
//
//  Created by Константин Кнор on 30.10.2022.
//

import UIKit
public enum Parameters: String {
    case height
    case diameter
    case mass
    case payloadWeights
}
class SettingsViewController: UIViewController {
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 246, green: 246, blue: 246)
        label.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        label.text =  "Высота"
        return label
    }()
    private let diameterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 246, green: 246, blue: 246)
        label.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        label.text =  "Диаметр"
        return label
    }()
    private let massLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 246, green: 246, blue: 246)
        label.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        label.text =  "Масса"
        return label
    }()
    private let payloadWeightsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 246, green: 246, blue: 246)
        label.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        label.text =  "Полезная нагрузка"
        return label
    }()
    private let firstSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["m","ft"])
        segment.selectedSegmentTintColor = UIColor(red: 255, green: 255, blue: 255)
        segment.backgroundColor = UIColor(red: 33, green: 33, blue: 33)
        if UserDefaults.standard.object(forKey: Parameters.height.rawValue) != nil {
            segment.selectedSegmentIndex = UserDefaults.standard.object(forKey: Parameters.height.rawValue) as! Int
        } else {
            segment.selectedSegmentIndex = 1
        }
        segment.addAction(UIAction(handler: { _ in
            UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: Parameters.height.rawValue)
        }), for: .allEvents)
        return segment
    }()
    private let secondSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["m","ft"])
        segment.selectedSegmentTintColor = UIColor(red: 255, green: 255, blue: 255)
        segment.backgroundColor = UIColor(red: 33, green: 33, blue: 33)
        if UserDefaults.standard.object(forKey: Parameters.diameter.rawValue) != nil {
            segment.selectedSegmentIndex = UserDefaults.standard.object(forKey: Parameters.diameter.rawValue) as! Int
        } else {
            segment.selectedSegmentIndex = 1
        }
        segment.addAction(UIAction(handler: { _ in
            UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: Parameters.diameter.rawValue)
        }), for: .allEvents)
        return segment
    }()
    private let thirdSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["kg","ld"])
        segment.selectedSegmentTintColor = UIColor(red: 255, green: 255, blue: 255)
        segment.backgroundColor = UIColor(red: 33, green: 33, blue: 33)
        if UserDefaults.standard.object(forKey: Parameters.mass.rawValue) != nil {
            segment.selectedSegmentIndex = UserDefaults.standard.object(forKey: Parameters.mass.rawValue) as! Int
        } else {
            segment.selectedSegmentIndex = 0
        }
        segment.addAction(UIAction(handler: { _ in
            UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: Parameters.mass.rawValue)
        }), for: .allEvents)
        return segment
    }()
    private let fourthSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["kg","ld"])
        segment.selectedSegmentTintColor = UIColor(red: 255, green: 255, blue: 255)
        segment.backgroundColor = UIColor(red: 33, green: 33, blue: 33)
        if UserDefaults.standard.object(forKey: Parameters.payloadWeights.rawValue) != nil {
            segment.selectedSegmentIndex = UserDefaults.standard.object(forKey: Parameters.payloadWeights.rawValue) as! Int
        } else {
            segment.selectedSegmentIndex = 1
        }
        segment.addAction(UIAction(handler: { _ in
            UserDefaults.standard.set(segment.selectedSegmentIndex, forKey: Parameters.payloadWeights.rawValue)
        }), for: .allEvents)
        return segment
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIColor.white]
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0)
        view.addSubview(heightLabel)
        view.addSubview(diameterLabel)
        view.addSubview(massLabel)
        view.addSubview(payloadWeightsLabel)
        //segments
        view.addSubview(firstSegment)
        view.addSubview(secondSegment)
        view.addSubview(thirdSegment)
        view.addSubview(fourthSegment)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heightLabel.frame = CGRect(x: 28,
                                   y: 120,
                                   width: 176,
                                   height: 24)
        diameterLabel.frame = CGRect(x: 28,
                                     y: heightLabel.frame.origin.y + 64,
                                     width: 176,
                                     height: 24)
        massLabel.frame = CGRect(x: 28,
                                 y: diameterLabel.frame.origin.y + 64,
                                 width: 176,
                                 height: 24)
        payloadWeightsLabel.frame = CGRect(x: 28,
                                           y: massLabel.frame.origin.y + 64,
                                           width: 176,
                                           height: 24)
        firstSegment.frame = CGRect(x: view.frame.width - 143,
                                    y: 112,
                                    width: 115,
                                    height: 40)
        secondSegment.frame = CGRect(x: view.frame.width - 143,
                                     y: firstSegment.frame.origin.y + 64,
                                     width: 115,
                                     height: 40)
        thirdSegment.frame = CGRect(x: view.frame.width - 143,
                                     y: secondSegment.frame.origin.y + 64,
                                     width: 115,
                                     height: 40)
        fourthSegment.frame = CGRect(x: view.frame.width - 143,
                                     y: thirdSegment.frame.origin.y + 64,
                                     width: 115,
                                     height: 40)
        
        
    }
}
