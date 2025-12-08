//
//  LobbyView.swift
//  WA_UI
//

import UIKit

class LobbyView: UIView {
    
    var labelTitle: UILabel!
    var buttonCreateRoom: UIButton!
    var tableViewRooms: UITableView!
    var logoutButton: UIButton!
    var headerCard: UIView!
    var roomsCard: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
        setupViews()
        initConstraints()
    }
    
    func setupViews() {
        // Logout Button (top right)
        logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: "Helvetica", size: 14) ?? .systemFont(ofSize: 14)
        logoutButton.setTitleColor(UIColor(red: 0.8, green: 0.4, blue: 0.4, alpha: 1.0), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        let logoutIcon = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        logoutButton.setImage(logoutIcon, for: .normal)
        logoutButton.tintColor = UIColor(red: 0.8, green: 0.4, blue: 0.4, alpha: 1.0)
        logoutButton.semanticContentAttribute = .forceLeftToRight
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        self.addSubview(logoutButton)
        
        // Header Card
        headerCard = createCard()
        self.addSubview(headerCard)
        
        let headerStack = UIStackView()
        headerStack.axis = .vertical
        headerStack.spacing = 16
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(headerStack)
        headerStack.tag = 100
        
        // Logo/Icon
        let logoIcon = UIImageView()
        logoIcon.image = UIImage(systemName: "gamecontroller.fill")
        logoIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        logoIcon.contentMode = .scaleAspectFit
        logoIcon.translatesAutoresizingMaskIntoConstraints = false
        headerStack.addArrangedSubview(logoIcon)
        logoIcon.tag = 101
        
        labelTitle = UILabel()
        labelTitle.text = "Game Lobby"
        labelTitle.font = UIFont(name: "Helvetica-Bold", size: 28) ?? .systemFont(ofSize: 28, weight: .bold)
        labelTitle.textAlignment = .center
        labelTitle.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        headerStack.addArrangedSubview(labelTitle)
        
        let divider = createDivider()
        headerStack.addArrangedSubview(divider)
        divider.tag = 102
        
        buttonCreateRoom = UIButton(type: .system)
        buttonCreateRoom.setTitle("Create Room", for: .normal)
        buttonCreateRoom.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        buttonCreateRoom.setTitleColor(.white, for: .normal)
        buttonCreateRoom.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        buttonCreateRoom.layer.cornerRadius = 12
        buttonCreateRoom.translatesAutoresizingMaskIntoConstraints = false
        let plusIcon = UIImage(systemName: "plus.circle.fill")
        buttonCreateRoom.setImage(plusIcon, for: .normal)
        buttonCreateRoom.tintColor = .white
        buttonCreateRoom.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        headerStack.addArrangedSubview(buttonCreateRoom)
        
        // Rooms Card
        roomsCard = createCard()
        self.addSubview(roomsCard)
        
        let roomsHeaderStack = UIStackView()
        roomsHeaderStack.axis = .horizontal
        roomsHeaderStack.spacing = 8
        roomsHeaderStack.alignment = .center
        roomsHeaderStack.translatesAutoresizingMaskIntoConstraints = false
        roomsCard.addSubview(roomsHeaderStack)
        roomsHeaderStack.tag = 103
        
        let roomsIcon = UIImageView()
        roomsIcon.image = UIImage(systemName: "list.bullet.rectangle.fill")
        roomsIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        roomsIcon.contentMode = .scaleAspectFit
        roomsIcon.translatesAutoresizingMaskIntoConstraints = false
        roomsHeaderStack.addArrangedSubview(roomsIcon)
        roomsIcon.tag = 104
        
        let roomsLabel = UILabel()
        roomsLabel.text = "Available Rooms"
        roomsLabel.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        roomsLabel.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        roomsHeaderStack.addArrangedSubview(roomsLabel)
        
        let roomsDivider = createDivider()
        roomsDivider.translatesAutoresizingMaskIntoConstraints = false
        roomsCard.addSubview(roomsDivider)
        roomsDivider.tag = 105
        
        tableViewRooms = UITableView()
        tableViewRooms.register(RoomTableViewCell.self, forCellReuseIdentifier: "RoomCell")
        tableViewRooms.backgroundColor = .clear
        tableViewRooms.separatorStyle = .none
        tableViewRooms.translatesAutoresizingMaskIntoConstraints = false
        roomsCard.addSubview(tableViewRooms)
    }
    
    func createCard() -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 8
        card.layer.shadowOpacity = 0.08
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }
    
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }
    
    func initConstraints() {
        guard let headerStack = headerCard.viewWithTag(100),
              let logoIcon = headerCard.viewWithTag(101),
              let divider = headerCard.viewWithTag(102),
              let roomsHeaderStack = roomsCard.viewWithTag(103),
              let roomsIcon = roomsCard.viewWithTag(104),
              let roomsDivider = roomsCard.viewWithTag(105) else { return }
        
        NSLayoutConstraint.activate([
            // Logout Button - top right
            logoutButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // Header Card
            headerCard.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 16),
            headerCard.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            headerCard.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            headerStack.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 24),
            headerStack.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -20),
            headerStack.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -24),
            
            logoIcon.widthAnchor.constraint(equalToConstant: 60),
            logoIcon.heightAnchor.constraint(equalToConstant: 60),
            
            divider.leadingAnchor.constraint(equalTo: headerStack.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: headerStack.trailingAnchor),
            
            buttonCreateRoom.widthAnchor.constraint(equalTo: headerStack.widthAnchor),
            buttonCreateRoom.heightAnchor.constraint(equalToConstant: 50),
            
            // Rooms Card
            roomsCard.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 20),
            roomsCard.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            roomsCard.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            roomsCard.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            roomsHeaderStack.topAnchor.constraint(equalTo: roomsCard.topAnchor, constant: 20),
            roomsHeaderStack.leadingAnchor.constraint(equalTo: roomsCard.leadingAnchor, constant: 20),
            
            roomsIcon.widthAnchor.constraint(equalToConstant: 24),
            roomsIcon.heightAnchor.constraint(equalToConstant: 24),
            
            roomsDivider.topAnchor.constraint(equalTo: roomsHeaderStack.bottomAnchor, constant: 16),
            roomsDivider.leadingAnchor.constraint(equalTo: roomsCard.leadingAnchor, constant: 20),
            roomsDivider.trailingAnchor.constraint(equalTo: roomsCard.trailingAnchor, constant: -20),
            
            tableViewRooms.topAnchor.constraint(equalTo: roomsDivider.bottomAnchor, constant: 8),
            tableViewRooms.leadingAnchor.constraint(equalTo: roomsCard.leadingAnchor, constant: 12),
            tableViewRooms.trailingAnchor.constraint(equalTo: roomsCard.trailingAnchor, constant: -12),
            tableViewRooms.bottomAnchor.constraint(equalTo: roomsCard.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
