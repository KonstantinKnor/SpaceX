//
//  LaunchesViewController.swift
//  SpaceX
//
//  Created by Константин Кнор on 30.10.2022.
//

import UIKit

class LaunchesViewController: UIViewController {
    
    private let tabelView: UITableView = {
        let tabel = UITableView()
        tabel.backgroundColor = UIColor.clear
        return tabel
    }()
    private var arrayLaunches: [Launches] = []
    public var currentRocket: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back))
        tabelView.register(LaunchesTabelViewCell.self, forCellReuseIdentifier: LaunchesTabelViewCell.identifier)
        DispatchQueue.main.async {
            sleep(1)
            self.tabelView.delegate = self
            self.tabelView.dataSource = self
        }
        
        view.addSubview(tabelView)
        getData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabelView.frame = CGRect(x: 32,
                                 y: 50,
                                 width: view.frame.size.width - 64,
                                 height: view.frame.size.height)
        
    }
    private func getData(){
        NetworkForLaunches.shered.getLaunches { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.getArrayLaunches(data: data)
                }
            case .failure(let error):
                print("Failed to decode launches",error)
            }
        }
    }
    
    @objc private func back(){
        navigationController?.popViewController(animated: true)
    }
    
    private func getArrayLaunches(data: [Launches]){
        data.map { [weak self] result in
            if result.rocket == currentRocket && !result.upcoming {
                self?.arrayLaunches.append(result)
            }
        }
        
    }
}

extension LaunchesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrayLaunches.count)
        return arrayLaunches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchesTabelViewCell.identifier, for: indexPath) as? LaunchesTabelViewCell else {
            return UITableViewCell()
        }
        cell.settingScreen(data: arrayLaunches[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}
