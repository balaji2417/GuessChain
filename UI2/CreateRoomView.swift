//
//  CreateRoomView.swift
//  WA_UI
//
//  Created by Gokhula Krishnan Thangavel on 11/16/25.
//

import UIKit

class CreateRoomView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var labelTitle: UILabel!
    var textFieldRoomName: UITextField!
    var buttonCreate: UIButton!
    var buttonCancel: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLabelTitle()
        setupTextFieldRoomName()
        setupButtonCreate()
        setupButtonCancel()
        
        initConstraints()
    }
    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.text = "Create Room"
        labelTitle.font = .boldSystemFont(ofSize: 28)
        labelTitle.textAlignment = .center
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTitle)
    }
    
    func setupTextFieldRoomName() {
        textFieldRoomName = UITextField()
        textFieldRoomName.placeholder = "Room Name"
        textFieldRoomName.borderStyle = .roundedRect
        textFieldRoomName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldRoomName)
    }
    
    func setupButtonCreate() {
        buttonCreate = UIButton(type: .system)
        buttonCreate.setTitle("Create", for: .normal)
        buttonCreate.titleLabel?.font = .boldSystemFont(ofSize: 16)
        buttonCreate.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCreate)
    }
    
    func setupButtonCancel() {
        buttonCancel = UIButton(type: .system)
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.titleLabel?.font = .systemFont(ofSize: 16)
        buttonCancel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonCancel)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60),
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            textFieldRoomName.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 40),
            textFieldRoomName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            textFieldRoomName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            buttonCreate.topAnchor.constraint(equalTo: textFieldRoomName.bottomAnchor, constant: 24),
            buttonCreate.leadingAnchor.constraint(equalTo: textFieldRoomName.leadingAnchor),
            buttonCreate.trailingAnchor.constraint(equalTo: textFieldRoomName.trailingAnchor),
            buttonCreate.heightAnchor.constraint(equalToConstant: 44),
            
            buttonCancel.topAnchor.constraint(equalTo: buttonCreate.bottomAnchor, constant: 16),
            buttonCancel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
