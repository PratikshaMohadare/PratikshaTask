//
//  CustomSegmentedControl.swift
//  PratikshaTask
//
//  Created by Pratiksha on 02/07/25.
//

import UIKit

class CustomSegmentedControl: UIView {
    
    // MARK: - Properties
    private var buttonTitles: [String]!
    private var buttons: [UIButton] = []
    private var selectorView: UIView!
    
    var textColor: UIColor = .gray
    var selectorTextColor: UIColor = .black
    var selectorViewColor: UIColor = .systemGray
    
    var selectedIndex: Int = 0
    
    // MARK: - Initializer
    convenience init(buttonTitles: [String]) {
        self.init(frame: .zero)
        self.buttonTitles = buttonTitles
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if buttons.isEmpty {
            updateView()
        }
    }
    
    // MARK: - UI Setup
    private func updateView() {
        createButtons()
        configSelectorView()
        configStackView()
    }
    
    private func createButtons() {
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    @objc func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                selectedIndex = buttonIndex
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height - 3, width: selectorWidth, height: 1))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
