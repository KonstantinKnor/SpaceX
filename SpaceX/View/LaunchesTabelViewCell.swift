//
//  LaunchesTabelViewCell.swift
//  SpaceX
//
//  Created by Константин Кнор on 30.10.2022.
//

import UIKit

class LaunchesTabelViewCell: UITableViewCell {
    static let identifier = "LaunchesCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 255, green: 255, blue: 255)
        label.font = UIFont(name: "LabGrotesque-Regular", size: 20)
        label.text =  "mcdcmdkc"
        return label
    }()
    
    private let imageViewRocket: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 142, green: 142, blue: 143)
        label.font = UIFont(name: "LabGrotesque-Regular", size: 16)
        label.text = "cmdkdc"
        return label
    }()
    private let viewCell: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 33, green: 33, blue: 33)
        view.layer.cornerRadius = 15
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewCell.addSubview(nameLabel)
        viewCell.addSubview(dateLabel)
        viewCell.addSubview(imageViewRocket)
        contentView.addSubview(viewCell)
        contentView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 24,
                                 y: 24,
                                 width: 140,
                                 height: 28)
        dateLabel.frame = CGRect(x: 24,
                                 y: 52,
                                 width: 140,
                                 height: 24)
        imageViewRocket.frame = CGRect(x: contentView.frame.width - 64,
                                       y: 34,
                                       width: 32,
                                       height: 32)
        viewCell.frame = CGRect(x: 0,
                                y: 8,
                                width: contentView.frame.size.width,
                                height: 100)
    }
    
    public func settingScreen(data: Launches){
        nameLabel.text = data.name
        dateLabel.text = data.date_utc.deletingСharacters().converterDate()
        guard let imageBool = data.success else { return }
        if imageBool {
            imageViewRocket.image = UIImage(named: "successfully")
        } else {
            imageViewRocket.image = UIImage(named: "failed")
        }
        
        
    }
}
