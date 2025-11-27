//
//  LobbyView.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

class LobbyView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var labelTitle: UILabel!
    var buttonCreateRoom: UIButton!
    var tableViewRooms: UITableView!
    var logoutButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLabelTitle()
        setupButtonCreateRoom()
        setupTableViewRooms()
        setupLogoutButton()
        
        initConstraints()
    }
    
    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.text = "Game Lobby"
        labelTitle.font = .boldSystemFont(ofSize: 28)
        labelTitle.textAlignment = .center
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTitle)
    }
    
    func setupButtonCreateRoom() {
        buttonCreateRoom = UIButton(type: .system)
        buttonCreateRoom.setTitle("Create Room", for: .normal)
        buttonCreateRoom.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonCreateRoom.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCreateRoom)
    }
    
    func setupTableViewRooms() {
        tableViewRooms = UITableView()
        tableViewRooms.register(RoomTableViewCell.self, forCellReuseIdentifier: "RoomCell")
        tableViewRooms.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewRooms)
    }
    
    func setupLogoutButton() {
        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoutButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            buttonCreateRoom.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            buttonCreateRoom.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            buttonCreateRoom.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            buttonCreateRoom.heightAnchor.constraint(equalToConstant: 44),
            
            logoutButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableViewRooms.topAnchor.constraint(equalTo: buttonCreateRoom.bottomAnchor, constant: 20),
            tableViewRooms.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewRooms.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableViewRooms.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
