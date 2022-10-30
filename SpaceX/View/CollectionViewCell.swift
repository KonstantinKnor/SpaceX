//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Константин Кнор on 26.10.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "collectionViewCell"
    private let nameOfLabelsArray: [String] = ["Высота, ft", "Диаметр,","Масса,","Нагрузка, "]
    private let numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.textColor = UIColor(red: 255, green: 255, blue: 255)
        numberLabel.font = UIFont(name: "LabGrotesque-Bold", size: 16)
        numberLabel.textAlignment = .center
        return numberLabel
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(red: 142, green: 142, blue: 143)
        textLabel.font = UIFont(name: "LabGrotesque-Regular", size: 14)
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(numberLabel)
        contentView.addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        numberLabel.frame = CGRect(x: 8,
                                   y: 28,
                                   width: 80,
                                   height: 24)
        
        textLabel.frame = CGRect(x: 8,
                                 y: 52,
                                 width: 80,
                                 height: 20)
        
    }
    
    public func settingUIElements(data: InfoAboutRocket, index: Int){
        switch index {
            case 0:
            firstValues(with: data)
            case 1:
            secondValues(with: data)
            case 2:
            thirdValues(with: data)
            case 3:
            fourthValues(with: data)
        default:
            break
        }
    }
    
    private func firstValues(with data: InfoAboutRocket){
        if let height = UserDefaults.standard.object(forKey: Parameters.height.rawValue) as? Int {
            switch height {
            case 0:
                numberLabel.text = String(data.height.meters)
                textLabel.text = "Высота, m"
            case 1:
                numberLabel.text = String(data.height.feet)
                textLabel.text = "Высота, ft"
            default:
                numberLabel.text = String(data.height.feet)
                textLabel.text = "Высота, ft"
            }
        } else {
            numberLabel.text = String(data.height.feet)
            textLabel.text = "Высота, ft"
        }
    }

    private func secondValues(with data: InfoAboutRocket){
        if let height = UserDefaults.standard.object(forKey: Parameters.diameter.rawValue) as? Int {
            switch height {
            case 0:
                numberLabel.text = String(data.diameter.meters)
                textLabel.text = "Диаметр, m"
            case 1:
                numberLabel.text = String(data.diameter.feet)
                textLabel.text = "Диаметр, ft"
            default:
                numberLabel.text = String(data.diameter.feet)
                textLabel.text = "Диаметр, ft"
            }
        } else {
            numberLabel.text = String(data.diameter.feet)
            textLabel.text = "Диаметр, ft"
        }
    }
    
    private func thirdValues(with data: InfoAboutRocket){
        if let height = UserDefaults.standard.object(forKey: Parameters.mass.rawValue) as? Int {
            switch height {
            case 0:
                numberLabel.text = String(data.mass.kg)
                textLabel.text = "Масса, kg"
            case 1:
                numberLabel.text = String(data.mass.lb)
                textLabel.text = "Масса, ld"
            default:
                numberLabel.text = String(data.mass.lb)
                textLabel.text = "Масса, ld"
            }
        } else {
            numberLabel.text = String(data.mass.lb)
            textLabel.text = "Масса, ld"
        }
    }
    
    private func fourthValues(with data: InfoAboutRocket){
        if let height = UserDefaults.standard.object(forKey: Parameters.payloadWeights.rawValue) as? Int {
            switch height {
            case 0:
                numberLabel.text = String(data.payload_weights[0].kg)
                textLabel.text = "Полезная нагрузка, kg"
            case 1:
                numberLabel.text = String(data.payload_weights[0].lb)
                textLabel.text = "Полезная нагрузка, ld"
            default:
                numberLabel.text = String(data.payload_weights[0].lb)
                textLabel.text = "Полезная нагрузка, ld"
            }
        } else {
            numberLabel.text = String(data.payload_weights[0].lb)
            textLabel.text = "Полезная нагрузка, ld"
        }
    }
}
