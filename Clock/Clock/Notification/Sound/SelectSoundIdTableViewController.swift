//
//  SelectSoundIdTableViewController.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

protocol SelectSoundIdDelegate {
    func getSoundId(soundId: Int)
}

enum SelectSoundIdFromWhere {
    case alarm, timer, itself
}

class SelectSoundIdTableViewController: UITableViewController, SelectSoundIdDelegate {

    var selectSoundIdDelegate: SelectSoundIdDelegate?
    var fromWhere: SelectSoundIdFromWhere?
    var soundId: Int!
    
    private var forClassic: Bool!
    private var sound: [String] {
        get {
            return self.fromWhere == .itself ? NotificationSound.soundClassic : NotificationSound.sound
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if fromWhere == .itself {
            navigationItem.backBarButtonItem?.title = "Back"
            navigationItem.backBarButtonItem?.tintColor = .mainTintColor
        }
        
        setupTableViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !forClassic {
            switch fromWhere {
            case .alarm:
                title = "Sound"
            case .timer:
                title = "When timer Ends"
            case .itself:
                title = "Classic"
            default:
                title = "Ringtones"
            }
        }
        PlayAudioFile.shared.stopPlaying()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        title = "Back"
    }
    
    private func setupTableViewProperties() {
        forClassic = self.fromWhere == .itself
        if let fromWhere = fromWhere {
            switch fromWhere {
            case .alarm:
                title = "Sound"
            case .timer:
                title = "When timer Ends"
            case .itself:
                title = "Classic"
            }
        } else {
            title = "Ringtones"
        }
        
        view.backgroundColor = .modalViewBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .rightDetailCellBackgroundColor
        navigationController?.navigationBar.titleTextAttributes = UIColor.whiteTextColorAttribution
        if !forClassic {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Set", style: .done, target: self, action: #selector(setAndDismissView))
        } else {
            navigationController?.navigationBar.tintColor = .mainTintColor
        }
        navigationItem.backBarButtonItem?.tintColor = .mainTintColor
        navigationItem.leftBarButtonItem?.tintColor = .mainTintColor
        navigationItem.rightBarButtonItem?.tintColor = .mainTintColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SelectSoundTableViewCell.self, forCellReuseIdentifier: SelectSoundTableViewCell.reuseIdentifier)
        tableView.separatorColor = .tableViewSeparatorColor
        
        if soundId == nil { self.soundId = NotificationSound.defaultID }
    }
    
    func getSoundId(soundId: Int) {
        self.soundId = soundId
        tableView.reloadData()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        PlayAudioFile.shared.stopPlaying()
        super.dismiss(animated: flag, completion: completion)
    }
    
    @objc private func setAndDismissView() {
        selectSoundIdDelegate?.getSoundId(soundId: soundId)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return forClassic ? 1 : 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? sound.count : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectSoundTableViewCell.reuseIdentifier, for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = sound[indexPath.row] + ((indexPath.row == 0 && !forClassic) ? " (Default)" : "")
            cell.imageView?.isHidden = indexPath.row != (forClassic ? soundId : soundId - NotificationSound.maxNumberOfClassic)
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Classic"
            cell.accessoryType = .disclosureIndicator
            if soundId < NotificationSound.maxNumberOfClassic {
                cell.imageView?.isHidden = false
                cell.detailTextLabel?.text = NotificationSound.soundClassic[soundId]
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            soundId = indexPath.row + (forClassic ? 0 : NotificationSound.maxNumberOfClassic)
            if forClassic { selectSoundIdDelegate?.getSoundId(soundId: soundId) }
            tableView.reloadData()
            PlayAudioFile.shared.playAudioFile(soundId: soundId)
        } else {
            PlayAudioFile.shared.stopPlaying()
            let selectSoundTVC = SelectSoundIdTableViewController()
            selectSoundTVC.selectSoundIdDelegate = self
            selectSoundTVC.soundId = soundId
            selectSoundTVC.fromWhere = .itself
            navigationController?.pushViewController(selectSoundTVC, animated: true)
        }
        
    }
    
}
