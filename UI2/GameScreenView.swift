//
//  GameScreen.swift
//  WA_UI
//
//  Created by Sudharshan Ramesh on 11/17/25.
//

import UIKit

class GameScreenView: UIView {

    
    var mainScroll: UIScrollView!
    var contentContainer: UIView!
    var timerCircle: UIView!
    var timerNum: UILabel!
    var scoreBox: UIView!
    var scoreTxt: UILabel!
    var promptCard: UIView!
    var promptTxt: UILabel!
    var categoryLabel: UILabel!
    var chainArea: UIScrollView!
    var chainLinks: UIStackView!
    var answerBox: UIView!
    var answerField: UITextField!
    var goBtn: UIButton!
    var shakeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.96, green: 0.95, blue: 0.93, alpha: 1.0)
        
        setupMainScroll()
        setupContentContainer()
        setupScoreBox()
        setupScoreTxt()
        setupTimerCircle()
        setupTimerNum()
        setupCategoryLabel()
        setupPromptCard()
        setupPromptTxt()
        setupChainArea()
        setupChainLinks()
        setupAnswerBox()
        setupAnswerField()
        setupGoBtn()
        setupShakeLabel()
        
        initConstraints()
    }
    
    func setupMainScroll() {
        mainScroll = UIScrollView()
        mainScroll.backgroundColor = .clear
        mainScroll.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainScroll)
    }
    
    func setupContentContainer() {
        contentContainer = UIView()
        contentContainer.backgroundColor = .clear
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        mainScroll.addSubview(contentContainer)
    }
    
    func setupScoreBox() {
        scoreBox = UIView()
        scoreBox.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        scoreBox.layer.cornerRadius = 18
        scoreBox.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(scoreBox)
    }
    
    func setupScoreTxt() {
        scoreTxt = UILabel()
        scoreTxt.text = "0"
        scoreTxt.font = UIFont(name: "Menlo-Bold", size: 20) ?? .monospacedSystemFont(ofSize: 20, weight: .bold)
        scoreTxt.textColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        scoreTxt.translatesAutoresizingMaskIntoConstraints = false
        scoreBox.addSubview(scoreTxt)
    }
    
    func setupTimerCircle() {
        timerCircle = UIView()
        timerCircle.backgroundColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        timerCircle.layer.cornerRadius = 45
        timerCircle.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(timerCircle)
    }
    
    func setupTimerNum() {
        timerNum = UILabel()
        timerNum.text = "30"
        timerNum.font = UIFont(name: "Menlo-Bold", size: 38) ?? .monospacedSystemFont(ofSize: 38, weight: .bold)
        timerNum.textColor = .white
        timerNum.textAlignment = .center
        timerNum.translatesAutoresizingMaskIntoConstraints = false
        timerCircle.addSubview(timerNum)
    }
    
    func setupCategoryLabel() {
        categoryLabel = UILabel()
        categoryLabel.text = "round 1"
        categoryLabel.font = UIFont(name: "Menlo", size: 13) ?? .monospacedSystemFont(ofSize: 13, weight: .regular)
        categoryLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        categoryLabel.textAlignment = .center
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(categoryLabel)
    }
    
    func setupPromptCard() {
        promptCard = UIView()
        promptCard.backgroundColor = .white
        promptCard.layer.cornerRadius = 16
        promptCard.layer.borderWidth = 2
        promptCard.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        promptCard.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(promptCard)
    }
    
    func setupPromptTxt() {
        promptTxt = UILabel()
        promptTxt.text = "a movie starting with S"
        promptTxt.font = UIFont(name: "Helvetica-Bold", size: 24) ?? .systemFont(ofSize: 24, weight: .bold)
        promptTxt.textAlignment = .center
        promptTxt.numberOfLines = 0
        promptTxt.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        promptTxt.translatesAutoresizingMaskIntoConstraints = false
        promptCard.addSubview(promptTxt)
    }
    
    func setupChainArea() {
        chainArea = UIScrollView()
        chainArea.backgroundColor = .clear
        chainArea.showsHorizontalScrollIndicator = false
        chainArea.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(chainArea)
    }
    
    func setupChainLinks() {
        chainLinks = UIStackView()
        chainLinks.axis = .horizontal
        chainLinks.spacing = 14
        chainLinks.translatesAutoresizingMaskIntoConstraints = false
        chainArea.addSubview(chainLinks)
    }
    
    func setupAnswerBox() {
        answerBox = UIView()
        answerBox.backgroundColor = .white
        answerBox.layer.cornerRadius = 28
        answerBox.layer.borderWidth = 2
        answerBox.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        answerBox.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(answerBox)
    }
    
    func setupAnswerField() {
        answerField = UITextField()
        answerField.placeholder = "your answer"
        answerField.font = UIFont(name: "Helvetica", size: 18) ?? .systemFont(ofSize: 18)
        answerField.textAlignment = .center
        answerField.translatesAutoresizingMaskIntoConstraints = false
        answerBox.addSubview(answerField)
    }
    
    func setupGoBtn() {
        goBtn = UIButton(type: .system)
        goBtn.setTitle("submit", for: .normal)
        goBtn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        goBtn.setTitleColor(.white, for: .normal)
        goBtn.backgroundColor = UIColor(red: 0.4, green: 0.75, blue: 0.6, alpha: 1.0)
        goBtn.layer.cornerRadius = 28
        goBtn.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(goBtn)
    }
    
    func setupShakeLabel() {
        shakeLabel = UILabel()
        shakeLabel.text = "shake to skip"
        shakeLabel.font = UIFont(name: "Menlo", size: 12) ?? .monospacedSystemFont(ofSize: 12, weight: .regular)
        shakeLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        shakeLabel.textAlignment = .center
        shakeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(shakeLabel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            mainScroll.topAnchor.constraint(equalTo: self.topAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentContainer.topAnchor.constraint(equalTo: mainScroll.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: mainScroll.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: mainScroll.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: mainScroll.widthAnchor),
            
            scoreBox.topAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.topAnchor, constant: 16),
            scoreBox.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            scoreBox.widthAnchor.constraint(equalToConstant: 80),
            scoreBox.heightAnchor.constraint(equalToConstant: 36),
            
            scoreTxt.centerXAnchor.constraint(equalTo: scoreBox.centerXAnchor),
            scoreTxt.centerYAnchor.constraint(equalTo: scoreBox.centerYAnchor),
            
            timerCircle.topAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.topAnchor, constant: 16),
            timerCircle.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            timerCircle.widthAnchor.constraint(equalToConstant: 90),
            timerCircle.heightAnchor.constraint(equalToConstant: 90),
            
            timerNum.centerXAnchor.constraint(equalTo: timerCircle.centerXAnchor),
            timerNum.centerYAnchor.constraint(equalTo: timerCircle.centerYAnchor),
            
            categoryLabel.topAnchor.constraint(equalTo: timerCircle.bottomAnchor, constant: 8),
            categoryLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            promptCard.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            promptCard.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            promptCard.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            
            promptTxt.centerXAnchor.constraint(equalTo: promptCard.centerXAnchor),
            promptTxt.centerYAnchor.constraint(equalTo: promptCard.centerYAnchor),
            promptTxt.leadingAnchor.constraint(equalTo: promptCard.leadingAnchor, constant: 20),
            promptTxt.trailingAnchor.constraint(equalTo: promptCard.trailingAnchor, constant: -20),
            promptTxt.topAnchor.constraint(equalTo: promptCard.topAnchor, constant: 16),
            promptTxt.bottomAnchor.constraint(equalTo: promptCard.bottomAnchor, constant: -16),
            
            chainArea.topAnchor.constraint(equalTo: promptCard.bottomAnchor, constant: 16),
            chainArea.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            chainArea.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            chainArea.heightAnchor.constraint(equalToConstant: 130),
            
            chainLinks.topAnchor.constraint(equalTo: chainArea.topAnchor, constant: 8),
            chainLinks.leadingAnchor.constraint(equalTo: chainArea.leadingAnchor, constant: 20),
            chainLinks.trailingAnchor.constraint(equalTo: chainArea.trailingAnchor, constant: -20),
            chainLinks.bottomAnchor.constraint(equalTo: chainArea.bottomAnchor, constant: -8),
            chainLinks.heightAnchor.constraint(equalToConstant: 110),
            
            answerBox.topAnchor.constraint(equalTo: chainArea.bottomAnchor, constant: 16),
            answerBox.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            answerBox.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            answerBox.heightAnchor.constraint(equalToConstant: 56),
            
            answerField.centerXAnchor.constraint(equalTo: answerBox.centerXAnchor),
            answerField.centerYAnchor.constraint(equalTo: answerBox.centerYAnchor),
            answerField.leadingAnchor.constraint(equalTo: answerBox.leadingAnchor, constant: 20),
            answerField.trailingAnchor.constraint(equalTo: answerBox.trailingAnchor, constant: -20),
            
            goBtn.topAnchor.constraint(equalTo: answerBox.bottomAnchor, constant: 16),
            goBtn.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            goBtn.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            goBtn.heightAnchor.constraint(equalToConstant: 56),
            
            shakeLabel.topAnchor.constraint(equalTo: goBtn.bottomAnchor, constant: 12),
            shakeLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            shakeLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -20)
        ])
    }
    
    func addLink(txt: String, playerName: String) {
        let linkCard = UIView()
        linkCard.backgroundColor = .white
        linkCard.layer.cornerRadius = 14
        linkCard.layer.borderWidth = 2
        linkCard.layer.borderColor = UIColor(red: 0.88, green: 0.87, blue: 0.85, alpha: 1.0).cgColor
        linkCard.translatesAutoresizingMaskIntoConstraints = false
        
        let nameTag = UILabel()
        nameTag.text = playerName
        nameTag.font = UIFont(name: "Menlo", size: 11) ?? .monospacedSystemFont(ofSize: 11, weight: .regular)
        nameTag.textColor = UIColor(red: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
        nameTag.textAlignment = .center
        nameTag.translatesAutoresizingMaskIntoConstraints = false
        linkCard.addSubview(nameTag)
        
        let answerTxt = UILabel()
        answerTxt.text = txt
        answerTxt.font = UIFont(name: "Helvetica-Bold", size: 15) ?? .systemFont(ofSize: 15, weight: .bold)
        answerTxt.textColor = UIColor(red: 0.25, green: 0.25, blue: 0.28, alpha: 1.0)
        answerTxt.numberOfLines = 2
        answerTxt.textAlignment = .center
        answerTxt.translatesAutoresizingMaskIntoConstraints = false
        linkCard.addSubview(answerTxt)
        
        let arrowTxt = UILabel()
        arrowTxt.text = "→"
        arrowTxt.font = UIFont(name: "Helvetica-Bold", size: 22) ?? .systemFont(ofSize: 22, weight: .bold)
        arrowTxt.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        arrowTxt.textAlignment = .center
        arrowTxt.translatesAutoresizingMaskIntoConstraints = false
        linkCard.addSubview(arrowTxt)
        
        NSLayoutConstraint.activate([
            linkCard.widthAnchor.constraint(equalToConstant: 110),
            
            nameTag.topAnchor.constraint(equalTo: linkCard.topAnchor, constant: 10),
            nameTag.centerXAnchor.constraint(equalTo: linkCard.centerXAnchor),
            
            answerTxt.centerXAnchor.constraint(equalTo: linkCard.centerXAnchor),
            answerTxt.centerYAnchor.constraint(equalTo: linkCard.centerYAnchor),
            answerTxt.leadingAnchor.constraint(equalTo: linkCard.leadingAnchor, constant: 8),
            answerTxt.trailingAnchor.constraint(equalTo: linkCard.trailingAnchor, constant: -8),
            
            arrowTxt.bottomAnchor.constraint(equalTo: linkCard.bottomAnchor, constant: -10),
            arrowTxt.centerXAnchor.constraint(equalTo: linkCard.centerXAnchor)
        ])
        
        chainLinks.addArrangedSubview(linkCard)
        
        DispatchQueue.main.async {
            let rightEdge = self.chainArea.contentSize.width - self.chainArea.bounds.width
            if rightEdge > 0 {
                self.chainArea.setContentOffset(CGPoint(x: rightEdge, y: 0), animated: true)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
