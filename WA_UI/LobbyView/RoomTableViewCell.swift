//
//  RoomTableViewCell.swift
//  WA_UI
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    var labelRoomName: UILabel!
    var labelPlayerCount: UILabel!
    var buttonJoin: UIButton!
    var cardView: UIView!
    var roomIcon: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        setupViews()
        initConstraints()
    }
    
    func setupViews() {
        // Card Container
        cardView = UIView()
        cardView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.97, alpha: 1.0)
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        // Room Icon
        roomIcon = UIImageView()
        roomIcon.image = UIImage(systemName: "door.left.hand.open")
        roomIcon.tintColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        roomIcon.contentMode = .scaleAspectFit
        roomIcon.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(roomIcon)
        
        // Room Name Label
        labelRoomName = UILabel()
        labelRoomName.font = UIFont(name: "Helvetica-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
        labelRoomName.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        labelRoomName.numberOfLines = 2
        labelRoomName.lineBreakMode = .byWordWrapping
        labelRoomName.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(labelRoomName)
        
        // Player Count Label
        labelPlayerCount = UILabel()
        labelPlayerCount.font = UIFont(name: "Helvetica", size: 13) ?? .systemFont(ofSize: 13)
        labelPlayerCount.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        labelPlayerCount.numberOfLines = 1
        labelPlayerCount.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(labelPlayerCount)
        
        // Join Button
        buttonJoin = UIButton(type: .system)
        buttonJoin.setTitle("Join", for: .normal)
        buttonJoin.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        buttonJoin.setTitleColor(.white, for: .normal)
        buttonJoin.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        buttonJoin.layer.cornerRadius = 8
        buttonJoin.translatesAutoresizingMaskIntoConstraints = false
        buttonJoin.setContentHuggingPriority(.required, for: .horizontal)
        buttonJoin.setContentCompressionResistancePriority(.required, for: .horizontal)
        cardView.addSubview(buttonJoin)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Card View
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Room Icon
            roomIcon.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            roomIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            roomIcon.widthAnchor.constraint(equalToConstant: 28),
            roomIcon.heightAnchor.constraint(equalToConstant: 28),
            
            // Join Button (anchor from right side first)
            buttonJoin.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            buttonJoin.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            buttonJoin.widthAnchor.constraint(equalToConstant: 70),
            buttonJoin.heightAnchor.constraint(equalToConstant: 36),
            
            // Room Name Label
            labelRoomName.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            labelRoomName.leadingAnchor.constraint(equalTo: roomIcon.trailingAnchor, constant: 12),
            labelRoomName.trailingAnchor.constraint(equalTo: buttonJoin.leadingAnchor, constant: -12),
            
            // Player Count Label
            labelPlayerCount.topAnchor.constraint(equalTo: labelRoomName.bottomAnchor, constant: 4),
            labelPlayerCount.leadingAnchor.constraint(equalTo: labelRoomName.leadingAnchor),
            labelPlayerCount.trailingAnchor.constraint(equalTo: labelRoomName.trailingAnchor),
            labelPlayerCount.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -14),
            
            // Card minimum height
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 76)
        ])
    }
    
    func configure(with room: Room) {
        labelRoomName.text = room.name
        labelPlayerCount.text = "\(room.players.count)/\(room.maxPlayers) players"
        
        // Update button state based on room availability
        if room.players.count >= room.maxPlayers {
            buttonJoin.setTitle("Full", for: .normal)
            buttonJoin.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
            buttonJoin.isEnabled = false
        } else {
            buttonJoin.setTitle("Join", for: .normal)
            buttonJoin.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
            buttonJoin.isEnabled = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
