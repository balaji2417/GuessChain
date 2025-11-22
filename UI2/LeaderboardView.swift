//
//  LeaderboardView.swift
//  WA_UI
//
//  Created by Sudharshan Ramesh on 11/17/25.
//


import UIKit

class LeaderboardView: UIView {

    
    var mainScroll: UIScrollView!
    var contentView: UIView!
    var titleLbl: UILabel!
    var roundLbl: UILabel!
    var podiumView: UIView!
    var firstBox: UIView!
    var secondBox: UIView!
    var thirdBox: UIView!
    var firstNameLbl: UILabel!
    var secondNameLbl: UILabel!
    var thirdNameLbl: UILabel!
    var firstScoreLbl: UILabel!
    var secondScoreLbl: UILabel!
    var thirdScoreLbl: UILabel!
    var playersTable: UITableView!
    var playAgainButton: UIButton!
    var backButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
        setupMainScroll()
        setupContentView()
        setupTitleLbl()
        setupRoundLbl()
        setupPodiumView()
        setupFirstBox()
        setupSecondBox()
        setupThirdBox()
        setupFirstNameLbl()
        setupSecondNameLbl()
        setupThirdNameLbl()
        setupFirstScoreLbl()
        setupSecondScoreLbl()
        setupThirdScoreLbl()
        setupPlayersTable()
        setupPlayAgainButton()
        setupBackButton()
        
        initConstraints()
    }
    
    func setupMainScroll() {
        mainScroll = UIScrollView()
        mainScroll.backgroundColor = .clear
        mainScroll.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainScroll)
    }
    
    func setupContentView() {
        contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainScroll.addSubview(contentView)
    }
    
    func setupTitleLbl() {
        titleLbl = UILabel()
        titleLbl.text = "leaderboard"
        titleLbl.font = UIFont(name: "Helvetica-Bold", size: 28) ?? .systemFont(ofSize: 28, weight: .bold)
        titleLbl.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)
    }
    
    func setupRoundLbl() {
        roundLbl = UILabel()
        roundLbl.text = "round 1 complete"
        roundLbl.font = UIFont(name: "Menlo", size: 13) ?? .monospacedSystemFont(ofSize: 13, weight: .regular)
        roundLbl.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        roundLbl.textAlignment = .center
        roundLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(roundLbl)
    }
    
    func setupPodiumView() {
        podiumView = UIView()
        podiumView.backgroundColor = .clear
        podiumView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(podiumView)
    }
    
    func setupFirstBox() {
        firstBox = UIView()
        firstBox.backgroundColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        firstBox.layer.cornerRadius = 12
        firstBox.translatesAutoresizingMaskIntoConstraints = false
        podiumView.addSubview(firstBox)
    }
    
    func setupSecondBox() {
        secondBox = UIView()
        secondBox.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        secondBox.layer.cornerRadius = 12
        secondBox.translatesAutoresizingMaskIntoConstraints = false
        podiumView.addSubview(secondBox)
    }
    
    func setupThirdBox() {
        thirdBox = UIView()
        thirdBox.backgroundColor = UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)
        thirdBox.layer.cornerRadius = 12
        thirdBox.translatesAutoresizingMaskIntoConstraints = false
        podiumView.addSubview(thirdBox)
    }
    
    func setupFirstNameLbl() {
        firstNameLbl = UILabel()
        firstNameLbl.text = "player1"
        firstNameLbl.font = UIFont(name: "Helvetica-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
        firstNameLbl.textColor = .white
        firstNameLbl.textAlignment = .center
        firstNameLbl.translatesAutoresizingMaskIntoConstraints = false
        firstBox.addSubview(firstNameLbl)
    }
    
    func setupSecondNameLbl() {
        secondNameLbl = UILabel()
        secondNameLbl.text = "player2"
        secondNameLbl.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        secondNameLbl.textColor = .white
        secondNameLbl.textAlignment = .center
        secondNameLbl.translatesAutoresizingMaskIntoConstraints = false
        secondBox.addSubview(secondNameLbl)
    }
    
    func setupThirdNameLbl() {
        thirdNameLbl = UILabel()
        thirdNameLbl.text = "player3"
        thirdNameLbl.font = UIFont(name: "Helvetica-Bold", size: 14) ?? .systemFont(ofSize: 14, weight: .bold)
        thirdNameLbl.textColor = .white
        thirdNameLbl.textAlignment = .center
        thirdNameLbl.translatesAutoresizingMaskIntoConstraints = false
        thirdBox.addSubview(thirdNameLbl)
    }
    
    func setupFirstScoreLbl() {
        firstScoreLbl = UILabel()
        firstScoreLbl.text = "100"
        firstScoreLbl.font = UIFont(name: "Menlo-Bold", size: 24) ?? .monospacedSystemFont(ofSize: 24, weight: .bold)
        firstScoreLbl.textColor = .white
        firstScoreLbl.textAlignment = .center
        firstScoreLbl.translatesAutoresizingMaskIntoConstraints = false
        firstBox.addSubview(firstScoreLbl)
    }
    
    func setupSecondScoreLbl() {
        secondScoreLbl = UILabel()
        secondScoreLbl.text = "80"
        secondScoreLbl.font = UIFont(name: "Menlo-Bold", size: 20) ?? .monospacedSystemFont(ofSize: 20, weight: .bold)
        secondScoreLbl.textColor = .white
        secondScoreLbl.textAlignment = .center
        secondScoreLbl.translatesAutoresizingMaskIntoConstraints = false
        secondBox.addSubview(secondScoreLbl)
    }
    
    func setupThirdScoreLbl() {
        thirdScoreLbl = UILabel()
        thirdScoreLbl.text = "60"
        thirdScoreLbl.font = UIFont(name: "Menlo-Bold", size: 20) ?? .monospacedSystemFont(ofSize: 20, weight: .bold)
        thirdScoreLbl.textColor = .white
        thirdScoreLbl.textAlignment = .center
        thirdScoreLbl.translatesAutoresizingMaskIntoConstraints = false
        thirdBox.addSubview(thirdScoreLbl)
    }
    
    func setupPlayersTable() {
        playersTable = UITableView()
        playersTable.backgroundColor = .clear
        playersTable.separatorStyle = .none
        playersTable.isScrollEnabled = false
        playersTable.register(PlayerCell.self, forCellReuseIdentifier: "PlayerCell")
        playersTable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playersTable)
    }
    
    func setupPlayAgainButton() {
        playAgainButton = UIButton(type: .system)
        playAgainButton.setTitle("play again", for: .normal)
        playAgainButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        playAgainButton.setTitleColor(.white, for: .normal)
        playAgainButton.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        playAgainButton.layer.cornerRadius = 28
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playAgainButton)
    }
    
    func setupBackButton() {
        backButton = UIButton(type: .system)
        backButton.setTitle("back to lobby", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16) ?? .systemFont(ofSize: 16, weight: .regular)
        backButton.setTitleColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            mainScroll.topAnchor.constraint(equalTo: self.topAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: mainScroll.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScroll.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScroll.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScroll.widthAnchor),
            
            titleLbl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            roundLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 4),
            roundLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            podiumView.topAnchor.constraint(equalTo: roundLbl.bottomAnchor, constant: 24),
            podiumView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            podiumView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            podiumView.heightAnchor.constraint(equalToConstant: 160),
            
            firstBox.centerXAnchor.constraint(equalTo: podiumView.centerXAnchor),
            firstBox.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor),
            firstBox.widthAnchor.constraint(equalToConstant: 90),
            firstBox.heightAnchor.constraint(equalToConstant: 120),
            
            firstNameLbl.topAnchor.constraint(equalTo: firstBox.topAnchor, constant: 12),
            firstNameLbl.centerXAnchor.constraint(equalTo: firstBox.centerXAnchor),
            
            firstScoreLbl.centerXAnchor.constraint(equalTo: firstBox.centerXAnchor),
            firstScoreLbl.centerYAnchor.constraint(equalTo: firstBox.centerYAnchor, constant: 8),
            
            secondBox.trailingAnchor.constraint(equalTo: firstBox.leadingAnchor, constant: -12),
            secondBox.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor),
            secondBox.widthAnchor.constraint(equalToConstant: 85),
            secondBox.heightAnchor.constraint(equalToConstant: 100),
            
            secondNameLbl.topAnchor.constraint(equalTo: secondBox.topAnchor, constant: 10),
            secondNameLbl.centerXAnchor.constraint(equalTo: secondBox.centerXAnchor),
            
            secondScoreLbl.centerXAnchor.constraint(equalTo: secondBox.centerXAnchor),
            secondScoreLbl.centerYAnchor.constraint(equalTo: secondBox.centerYAnchor, constant: 6),
            
            thirdBox.leadingAnchor.constraint(equalTo: firstBox.trailingAnchor, constant: 12),
            thirdBox.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor),
            thirdBox.widthAnchor.constraint(equalToConstant: 85),
            thirdBox.heightAnchor.constraint(equalToConstant: 80),
            
            thirdNameLbl.topAnchor.constraint(equalTo: thirdBox.topAnchor, constant: 10),
            thirdNameLbl.centerXAnchor.constraint(equalTo: thirdBox.centerXAnchor),
            
            thirdScoreLbl.centerXAnchor.constraint(equalTo: thirdBox.centerXAnchor),
            thirdScoreLbl.centerYAnchor.constraint(equalTo: thirdBox.centerYAnchor, constant: 6),
            
            playersTable.topAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: 20),
            playersTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            playersTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            playersTable.heightAnchor.constraint(equalToConstant: 180),
            
            playAgainButton.topAnchor.constraint(equalTo: playersTable.bottomAnchor, constant: 20),
            playAgainButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            playAgainButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            playAgainButton.heightAnchor.constraint(equalToConstant: 56),
            
            backButton.topAnchor.constraint(equalTo: playAgainButton.bottomAnchor, constant: 12),
            backButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayerCell: UITableViewCell {
    
    var rankLbl: UILabel!
    var nameLbl: UILabel!
    var scoreLbl: UILabel!
    var cellBox: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        setupCellBox()
        setupRankLbl()
        setupNameLbl()
        setupScoreLbl()
        
        initConstraints()
    }
    
    func setupCellBox() {
        cellBox = UIView()
        cellBox.backgroundColor = .white
        cellBox.layer.cornerRadius = 12
        cellBox.layer.borderWidth = 2
        cellBox.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        cellBox.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellBox)
    }
    
    func setupRankLbl() {
        rankLbl = UILabel()
        rankLbl.text = "4"
        rankLbl.font = UIFont(name: "Menlo-Bold", size: 18) ?? .monospacedSystemFont(ofSize: 18, weight: .bold)
        rankLbl.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        rankLbl.translatesAutoresizingMaskIntoConstraints = false
        cellBox.addSubview(rankLbl)
    }
    
    func setupNameLbl() {
        nameLbl = UILabel()
        nameLbl.text = "player4"
        nameLbl.font = UIFont(name: "Helvetica-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
        nameLbl.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        cellBox.addSubview(nameLbl)
    }
    
    func setupScoreLbl() {
        scoreLbl = UILabel()
        scoreLbl.text = "40"
        scoreLbl.font = UIFont(name: "Menlo-Bold", size: 16) ?? .monospacedSystemFont(ofSize: 16, weight: .bold)
        scoreLbl.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        scoreLbl.translatesAutoresizingMaskIntoConstraints = false
        cellBox.addSubview(scoreLbl)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            cellBox.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            cellBox.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            cellBox.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            cellBox.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            cellBox.heightAnchor.constraint(equalToConstant: 50),
            
            rankLbl.leadingAnchor.constraint(equalTo: cellBox.leadingAnchor, constant: 16),
            rankLbl.centerYAnchor.constraint(equalTo: cellBox.centerYAnchor),
            
            nameLbl.leadingAnchor.constraint(equalTo: rankLbl.trailingAnchor, constant: 20),
            nameLbl.centerYAnchor.constraint(equalTo: cellBox.centerYAnchor),
            
            scoreLbl.trailingAnchor.constraint(equalTo: cellBox.trailingAnchor, constant: -16),
            scoreLbl.centerYAnchor.constraint(equalTo: cellBox.centerYAnchor)
        ])
    }
    
    func configure(rank: Int, name: String, score: Int) {
        rankLbl.text = "\(rank)"
        nameLbl.text = name
        scoreLbl.text = "\(score)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
