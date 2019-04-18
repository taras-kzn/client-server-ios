//
//  SelectLetterControl.swift
//  Weather
//
//  Created by admin on 12/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

enum Letter : Int,CaseIterable{
    case а
    case б
    case в
    case г
    case д
    case е
    case ж
    case з
    case и
    case к
    case л
    case м
    case н
    case о
    case п
    case р
    case с
    case т
    case у
    case ф
    case х
    case ц
    case ч
    case ш
    case э
    case ю
    case я
    
    var title: String {
        switch self {
        case .а: return "a"
        case .б: return "б"
        case .в: return "в"
        case .г: return "г"
        case .д: return "д"
        case .е: return "е"
        case .ж: return "ж"
        case .з: return "з"
        case .и: return "и"
        case .к: return "к"
        case .л: return "л"
        case .м: return "м"
        case .н: return "н"
        case .о: return "о"
        case .п: return "п"
        case .р: return "р"
        case .с: return "с"
        case .т: return "т"
        case .у: return "у"
        case .ф: return "ф"
        case .х: return "х"
        case .ц: return "ц"
        case .ч: return "ч"
        case .ш: return "ш"
        case .э: return "э"
        case .ю: return "ю"
        case .я: return "я"
        
        }
    }
    
}

class SelectLetterControl: UIControl {
    
    var selectLetter : Letter?{
        didSet {
            updateSelectedLetter()
            sendActions(for: .valueChanged)
        }
    }
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView?.frame = bounds
    }
    
    private func setupView() {
        for letter in Letter.allCases {
            let button = UIButton(type: .system)
            button.setTitle(letter.title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectLetterr(_sender:)) ,for: .touchUpInside)
            self.buttons.append(button)
        }
        
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        self.addSubview(stackView)
        
        
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
      
        
    
    }
    
    private func updateSelectedLetter() {
        for (index, button) in self.buttons.enumerated() {
            guard let letter = Letter(rawValue: index) else {
                continue
                
            }
            button.isSelected = letter == self.selectLetter
        }
    }
    
    @objc func selectLetterr(_sender: UIButton) {
        guard let index = buttons.index(of: _sender) else {
            return
            
        }
        guard let letter = Letter(rawValue: index) else {
            return
            
        }
        self.selectLetter = letter
        
    }
    
    
  

}
