//
//  RoomTableViewCell.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    var labelRoomName: UILabel!
    var labelPlayerCount: UILabel!
    var stackViewPlayers: UIStackView!
    var buttonJoin: UIButton!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLabelRoomName()
        setupLabelPlayerCount()
        setupStackViewPlayers()
        setupButtonJoin()
        
        initConstraints()
    }
    
    func setupLabelRoomName() {
        labelRoomName = UILabel()
        labelRoomName.font = .boldSystemFont(ofSize: 18)
        labelRoomName.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(labelRoomName)
    }
    
    func setupLabelPlayerCount() {
        labelPlayerCount = UILabel()
        labelPlayerCount.font = .systemFont(ofSize: 14)
        labelPlayerCount.textColor = .gray
        labelPlayerCount.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(labelPlayerCount)
    }
    
    func setupStackViewPlayers() {
        stackViewPlayers = UIStackView()
        stackViewPlayers.axis = .horizontal
        stackViewPlayers.spacing = 4
        stackViewPlayers.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(stackViewPlayers)
    }
    
    func setupButtonJoin() {
        buttonJoin = UIButton(type: .system)
        buttonJoin.setTitle("Join", for: .normal)
        buttonJoin.titleLabel?.font = .boldSystemFont(ofSize: 14)
        buttonJoin.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(buttonJoin)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelRoomName.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            labelRoomName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            
            labelPlayerCount.topAnchor.constraint(equalTo: labelRoomName.bottomAnchor, constant: 4),
            labelPlayerCount.leadingAnchor.constraint(equalTo: labelRoomName.leadingAnchor),
            
            stackViewPlayers.topAnchor.constraint(equalTo: labelPlayerCount.bottomAnchor, constant: 8),
            stackViewPlayers.leadingAnchor.constraint(equalTo: labelRoomName.leadingAnchor),
            stackViewPlayers.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            
            buttonJoin.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            buttonJoin.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            buttonJoin.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with room: Room) {
        labelRoomName.text = room.name
        labelPlayerCount.text = "\(room.players.count)/\(room.maxPlayers) players"
        
        stackViewPlayers.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
      
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
