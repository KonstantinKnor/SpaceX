//
//  ViewController.swift
//  SpaceX
//
//  Created by Константин Кнор on 26.10.2022.
//

import UIKit

class MainViewController: UIViewController {
    private let network = NetworkServices()
    private var collectionView: UICollectionView?
    private let arrayColletionView: [Int] = [1,2,3,4]
    private var arrayOfImages: [UIImage]?
    private var infoAboutRocketArray: [InfoAboutRocket]?
    private var currentPage = 0
    private var indexForColletionView = 0
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        return scrollView
    }()
    private var pageControll: UIPageControl = {
        let pageControll = UIPageControl()
        pageControll.numberOfPages = 4
        pageControll.backgroundStyle = .minimal
        pageControll.currentPageIndicatorTintColor = UIColor(red: 255, green: 255, blue: 255)
        pageControll.pageIndicatorTintColor = UIColor(red: 142, green: 142, blue: 143)
        return pageControll
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(pageControll)
        scrollView.delegate = self
        
        network.jsonRequest(completion: {[weak self] jsonResult in
            switch jsonResult {
            case .success(let json):
                DispatchQueue.main.async {
                    self?.network.downloadImages(with: json) { images in
                        DispatchQueue.main.async {
                            self?.infoAboutRocketArray = json
                            self?.arrayOfImages = images
                            self?.configureScrollView()
                        }
                  }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    //MARK: - Setting collectionView
    private func settingCollectionView(view: UIView){
        let frame = CGRect(x: 32,
                           y: 112,
                           width: view.frame.width - 32,
                           height: 96)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 96, height: 96)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        //collectionView.allowsSelection = false
        view.addSubview(collectionView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        pageControll.frame = CGRect(x: (view.frame.width - 140)/2,
                                    y: view.frame.height - (view.frame.height / 12),
                                    width: 140,
                                    height: 30)
        scrollView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.bounds.width,
                                  height: view.bounds.height)
    }
    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.bounds.width * 4 , height: 1138)
        scrollView.isPagingEnabled = true
        guard let infoAboutRocketArray = self.infoAboutRocketArray else { return }
        for x in 0...3 {
            self.indexForColletionView = x
            let imageView: UIImageView = {
                guard let arrayOfImages = arrayOfImages else {
                    return UIImageView(image: UIImage(named: "Falcon1"))
                }
                let imageView = UIImageView(image: arrayOfImages[x])
                return imageView
            }()
            let launches: UIButton = {
                let launches = UIButton(primaryAction: UIAction(handler: {[weak self] _ in
                    guard let currentPage = self?.currentPage else { return }
                    let vc = LaunchesViewController()
                    vc.title = infoAboutRocketArray[currentPage].name
                    vc.currentRocket = infoAboutRocketArray[currentPage].id
                    self?.navigationController?.pushViewController(vc, animated: true)
                }))
                launches.layer.cornerRadius = 10
                launches.backgroundColor = UIColor(red: 33, green: 33, blue: 33)
                launches.setTitle("Посмотреть запуски", for: .normal)
                launches.titleLabel?.font = UIFont(name: "LabGrotesque-Bold", size: 18)
                launches.setTitleColor(UIColor(red: 255, green: 255, blue: 255), for: .normal)
                return launches
            }()
            let blackView: UIView = {
                let blackView = UIView()
                blackView.layer.cornerRadius = 30
                blackView.backgroundColor = UIColor(red: 0, green: 0, blue: 0)
                return blackView
            }()
            let nameOfRocketLabel: UILabel = {
                let nameOfRocketLabel = UILabel()
                nameOfRocketLabel.font = UIFont(name: "LabGrotesque-Medium", size: 24)
                nameOfRocketLabel.textColor = UIColor(red: 246, green: 246, blue: 246)
                nameOfRocketLabel.text = infoAboutRocketArray[x].name
                return nameOfRocketLabel
            }()
            let settingsButton: UIButton = {
                let settingsButton = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
                    let vc = SettingsViewController()
                    let navVC = UINavigationController(rootViewController: vc)
                    self?.present(navVC, animated: true)
                }))
                let image = UIImage(named: "settings")
                let tintedImage = image?.withRenderingMode(.alwaysTemplate)
                settingsButton.setImage(tintedImage, for: .normal)
                settingsButton.tintColor = UIColor(red: 255, green: 255, blue: 255)
                return settingsButton
            }()
            imageView.frame = CGRect(x: view.frame.width * CGFloat(x),
                                     y: scrollView.frame.origin.y - 50,
                                     width: view.bounds.width,
                                     height: 388)
            blackView.frame = CGRect(x: view.frame.width * CGFloat(x),
                                     y: imageView.frame.size.height - 100,
                                     width: view.bounds.width,
                                     height: 920)
            nameOfRocketLabel.frame = CGRect(x: 32,
                                             y: 48,
                                             width: 146,
                                             height: 32)
            settingsButton.frame = CGRect(x: view.frame.width - 60.71,
                                          y: 50.67,
                                          width: 25.71,
                                          height: 27.63)
            let widthLaunches = view.bounds.width - 64
            launches.frame = CGRect(x: (view.frame.width - widthLaunches)/2,
                                    y: 740,
                                    width: widthLaunches,
                                    height: 50)
            
            scrollView.addSubview(imageView)
            scrollView.addSubview(blackView)
            blackView.addSubview(nameOfRocketLabel)
            blackView.addSubview(settingsButton)
            blackView.addSubview(launches)
            
            settingCollectionView(view: blackView)
            settingLeftLabels(view: blackView)
            settingRightLabels(view: blackView, index: x)
        }
    }
    private func settingLeftLabels(view: UIView) {
        
        let firstLaunch: UILabel = {
            let firstLaunch = UILabel()
            firstLaunch.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            firstLaunch.textColor = UIColor(red: 202, green: 202, blue: 202)
            firstLaunch.text = "Первый запуск"
            firstLaunch.frame = CGRect(x: 32,
                                       y: 248,
                                       width: 176,
                                       height: 24)
            return firstLaunch
        }()
        let country: UILabel = {
            let country = UILabel()
            country.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            country.textColor = UIColor(red: 202, green: 202, blue: 202)
            country.text = "Страна"
            country.frame = CGRect(x: 32,
                                   y: firstLaunch.frame.origin.y + 40,
                                   width: 176,
                                   height: 24)
            return country
        }()
        
        let launchCost: UILabel = {
            let launchCost = UILabel()
            launchCost.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            launchCost.textColor = UIColor(red: 202, green: 202, blue: 202)
            launchCost.text = "Стоимость запуска"
            launchCost.frame = CGRect(x: 32,
                                      y: country.frame.origin.y + 40,
                                      width: 176,
                                      height: 24)
            return launchCost
        }()
        
        let firstStage: UILabel = {
            let firstStage = UILabel()
            firstStage.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            firstStage.textColor = UIColor(red: 246, green: 246, blue: 246)
            firstStage.text = "ПЕРВАЯ СТУПЕНЬ"
            firstStage.frame = CGRect(x: 32,
                                      y: firstLaunch.frame.origin.y + 144,
                                      width: 176,
                                      height: 24)
            return firstStage
        }()
        
        let numberOfEngines: UILabel = {
            let numberOfEngines = UILabel()
            numberOfEngines.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            numberOfEngines.textColor = UIColor(red: 202, green: 202, blue: 202)
            numberOfEngines.text = "Количество двигателей"
            numberOfEngines.frame = CGRect(x: 32,
                                           y: firstStage.frame.origin.y + 40,
                                           width: 190,
                                           height: 24)
            return numberOfEngines
        }()
        
        let fuelQuantity: UILabel = {
            let fuelQuantity = UILabel()
            fuelQuantity.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            fuelQuantity.textColor = UIColor(red: 202, green: 202, blue: 202)
            fuelQuantity.text = "Количество топлива"
            fuelQuantity.frame = CGRect(x: 32,
                                        y: numberOfEngines.frame.origin.y + 40,
                                        width: 176,
                                        height: 24)
            return fuelQuantity
        }()
        
        let combustionTime: UILabel = {
            let combustionTime = UILabel()
            combustionTime.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            combustionTime.textColor = UIColor(red: 202, green: 202, blue: 202)
            combustionTime.text = "Время сгорания"
            combustionTime.frame = CGRect(x: 32,
                                        y: fuelQuantity.frame.origin.y + 40,
                                        width: 176,
                                        height: 24)
            return combustionTime
        }()
        
        let secondStage: UILabel = {
            let secondStage = UILabel()
            secondStage.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            secondStage.textColor = UIColor(red: 246, green: 246, blue: 246)
            secondStage.text = "ВТОРАЯ СТУПЕНЬ"
            secondStage.frame = CGRect(x: 32,
                                        y: numberOfEngines.frame.origin.y + 144,
                                        width: 176,
                                        height: 24)
            return secondStage
        }()
        
        let numberOfEngines2: UILabel = {
            let numberOfEngines = UILabel()
            numberOfEngines.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            numberOfEngines.textColor = UIColor(red: 202, green: 202, blue: 202)
            numberOfEngines.text = "Количество двигателей"
            numberOfEngines.frame = CGRect(x: 32,
                                        y: secondStage.frame.origin.y + 40,
                                        width: 190,
                                        height: 24)
            return numberOfEngines
        }()
        
        let fuelQuantity2: UILabel = {
            let fuelQuantity = UILabel()
            fuelQuantity.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            fuelQuantity.textColor = UIColor(red: 202, green: 202, blue: 202)
            fuelQuantity.text = "Количество топлива"
            fuelQuantity.frame = CGRect(x: 32,
                                        y: numberOfEngines2.frame.origin.y + 40,
                                        width: 176,
                                        height: 24)
            return fuelQuantity
        }()
        
        let combustionTime2: UILabel = {
            let combustionTime = UILabel()
            combustionTime.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            combustionTime.textColor = UIColor(red: 202, green: 202, blue: 202)
            combustionTime.text = "Время сгорания"
            combustionTime.frame = CGRect(x: 32,
                                        y: fuelQuantity2.frame.origin.y + 40,
                                        width: 176,
                                        height: 24)
            return combustionTime
        }()
       
        view.addSubview(firstLaunch)
        view.addSubview(country)
        view.addSubview(launchCost)
        view.addSubview(firstStage)
        view.addSubview(numberOfEngines)
        view.addSubview(fuelQuantity)
        view.addSubview(combustionTime)
        view.addSubview(secondStage)
        view.addSubview(numberOfEngines2)
        view.addSubview(fuelQuantity2)
        view.addSubview(combustionTime2)
        
    }
    
    private func settingRightLabels(view: UIView, index:Int){
        guard let infoAboutRocketArray = infoAboutRocketArray else { return }
        
        let date: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.text = infoAboutRocketArray[index].first_flight.converterDate()
            label.textAlignment = .right
            label.frame = CGRect(x: 213,
                                 y: 248,
                                 width: 130,
                                 height: 24)
            return label
        }()
        
        let country: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.text = infoAboutRocketArray[index].country.shortСountry()
            label.textAlignment = .right
            label.frame = CGRect(x: 136,
                                 y: date.frame.origin.y + 40,
                                 width: 207,
                                 height: 24)
            return label
        }()
        
        let cost: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Regular", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.text = infoAboutRocketArray[index].cost_per_launch.millionsOfDollars()
            label.textAlignment = .right
            label.frame = CGRect(x: 285,
                                 y: country.frame.origin.y + 40,
                                 width: 58,
                                 height: 24)
            return label
        }()
        let numberOfEngines: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.text = String(infoAboutRocketArray[index].first_stage.engines)
            label.textAlignment = .right
            label.frame = CGRect(x: 227,
                                 y: 432,
                                 width: 80,
                                 height: 24)
            return label
        }()
        
        let fuelQuantity: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.text = String(infoAboutRocketArray[index].first_stage.fuel_amount_tons)
            label.textAlignment = .right
            label.frame = CGRect(x: 227,
                                 y: numberOfEngines.frame.origin.y + 40,
                                 width: 80,
                                 height: 24)
            return label
        }()
        let ton: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 142, green: 142, blue: 143)
            label.text = "ton"
            label.textAlignment = .right
            label.frame = CGRect(x: 315,
                                 y: numberOfEngines.frame.origin.y + 40,
                                 width: 28,
                                 height: 24)
            return label
        }()
        let combustionTime: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.textAlignment = .right
            label.frame = CGRect(x: 227,
                                 y: fuelQuantity.frame.origin.y + 40,
                                 width: 80,
                                 height: 24)
            guard let time = infoAboutRocketArray[index].first_stage.burn_time_sec else { return UILabel() }
            label.text = String(time)
            return label
        }()
        
        let sec: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 142, green: 142, blue: 143)
            label.text = "sec"
            label.textAlignment = .right
            label.frame = CGRect(x: 315,
                                 y: fuelQuantity.frame.origin.y + 40,
                                 width: 28,
                                 height: 24)
            return label
        }()
        let numberOfEngines2: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.text = String(infoAboutRocketArray[index].second_stage.engines)
            label.textAlignment = .right
            label.frame = CGRect(x: 227,
                                 y: sec.frame.origin.y + 104,
                                 width: 80,
                                 height: 24)
            return label
        }()
        
        let fuelQuantity2: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.text = String(infoAboutRocketArray[index].second_stage.fuel_amount_tons)
            label.textAlignment = .right
            label.frame = CGRect(x: 227,
                                 y: numberOfEngines2.frame.origin.y + 40,
                                 width: 80,
                                 height: 24)
            return label
        }()
        let ton2: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 142, green: 142, blue: 143)
            label.text = "ton"
            label.textAlignment = .right
            label.frame = CGRect(x: 315,
                                 y: numberOfEngines2.frame.origin.y + 40,
                                 width: 28,
                                 height: 24)
            return label
        }()
        let combustionTime2: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 246, green: 246, blue: 246)
            label.text = "cmdk"
            label.textAlignment = .right
            label.frame = CGRect(x: 227,
                                 y: fuelQuantity2.frame.origin.y + 40,
                                 width: 80,
                                 height: 24)
            guard let time = infoAboutRocketArray[index].second_stage.burn_time_sec else { return UILabel() }
            label.text = String(time)
            return label
        }()
        let sec2: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "LabGrotesque-Bold", size: 16)
            label.textColor = UIColor(red: 142, green: 142, blue: 143)
            label.text = "sec"
            label.textAlignment = .right
            label.frame = CGRect(x: 315,
                                 y: fuelQuantity2.frame.origin.y + 40,
                                 width: 28,
                                 height: 24)
            return label
        }()
        view.addSubview(date)
        view.addSubview(country)
        view.addSubview(cost)
        view.addSubview(numberOfEngines)
        view.addSubview(fuelQuantity)
        view.addSubview(ton)
        view.addSubview(combustionTime)
        view.addSubview(sec)
        view.addSubview(numberOfEngines2)
        view.addSubview(fuelQuantity2)
        view.addSubview(ton2)
        view.addSubview(combustionTime2)
        view.addSubview(sec2)
    }
    
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControll.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        currentPage = pageControll.currentPage
    }
}

//MARK: - extension UICollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell() }
        guard let infoAboutRocketArray = infoAboutRocketArray else {return UICollectionViewCell()}
        cell.layer.cornerRadius = 32
        cell.backgroundColor = UIColor(red: 33, green: 33, blue: 33)
        indexForColletionView += 1
        switch indexForColletionView {
        case 1...4:
            cell.settingUIElements(data: infoAboutRocketArray[0], index: indexPath.row)
        case 5...8:
            cell.settingUIElements(data: infoAboutRocketArray[1], index: indexPath.row)
        case 9...12:
            cell.settingUIElements(data: infoAboutRocketArray[1], index: indexPath.row)
        case 13...16:
            cell.settingUIElements(data: infoAboutRocketArray[1], index: indexPath.row)
        default:
            cell.settingUIElements(data: infoAboutRocketArray[indexPath.row], index: indexPath.row)
        }
        return cell
    }
}




