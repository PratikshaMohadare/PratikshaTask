//
//  PortfolioSummaryView.swift
//  PratikshaTask
//
//  Created by Pratiksha on 01/07/25.
//

import UIKit

class PortfolioSummaryView: UIView {
    
    // MARK: - Properties
    private(set) var isExpanded = false

    // MARK: - UI Components
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.up"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.alpha = 0.0
        return view
    }()
    
    private let profitLossTitleLabel = UILabel(text: "Profit & Loss*", font: .systemFont(ofSize: 16, weight: .bold), textColor: .darkGray)
    private let profitLossValueLabel = UILabel(font: .systemFont(ofSize: 16), textAlignment: .right)
    
    private let todaysPNLLabel = PortfolioDetailRowView(title: "Today's Profit & Loss*")
    private let totalInvestmentLabel = PortfolioDetailRowView(title: "Total Investment*")
    private let currentValueLabel = PortfolioDetailRowView(title: "Current Value*")
    
    private lazy var expandableContentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [currentValueLabel, totalInvestmentLabel, todaysPNLLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alpha = 0.0
        return stack
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        // This stack group contains the title and the chevron, aligned to the left.
        let leftBottomStack = UIStackView(arrangedSubviews: [profitLossTitleLabel, chevronImageView])
        leftBottomStack.spacing = 8
        leftBottomStack.alignment = .center
        
        // A spacer view will push the left and right elements apart.
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // This is the main horizontal stack for the entire bottom row.
        let bottomRowStack = UIStackView(arrangedSubviews: [leftBottomStack, spacerView, profitLossValueLabel])
        
        // This is the main vertical stack for laying out all internal content.
        let mainVerticalStack = UIStackView(arrangedSubviews: [expandableContentStackView, separatorView, bottomRowStack])
        mainVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        mainVerticalStack.axis = .vertical
        mainVerticalStack.spacing = 12
        
        addSubview(mainVerticalStack)

        expandableContentStackView.isHidden = true
        separatorView.isHidden = true

        let topConstraint = mainVerticalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        
        let bottomConstraint = mainVerticalStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12)
        bottomConstraint.priority = .defaultHigh // Give this higher importance

        NSLayoutConstraint.activate([
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            
            topConstraint,
            mainVerticalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainVerticalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bottomConstraint,
            
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Public Methods
    func update(with viewModel: PortfolioViewModel) {
        currentValueLabel.setValue(viewModel.currentValue)
        totalInvestmentLabel.setValue(viewModel.totalInvestment)
        todaysPNLLabel.setValue(viewModel.todaysPNL)
        
        let pnlValue = viewModel.totalPNL
        let pnlPercentage = viewModel.profitLossPercentage
        
        let valueString: String
        let percentageSign = pnlPercentage >= 0 ? "+" : ""
        valueString = String(format: "%@ (%@%.2f%%)", pnlValue.toCurrency(), percentageSign, abs(pnlPercentage))
        
        profitLossValueLabel.text = valueString
        profitLossValueLabel.textColor = pnlValue >= 0 ? UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0) : .systemRed
    }
    
    func toggleState() {
        isExpanded.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.chevronImageView.transform = self.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            self.expandableContentStackView.alpha = self.isExpanded ? 1.0 : 0.0
            self.separatorView.alpha = self.isExpanded ? 1.0 : 0.0
            
            self.expandableContentStackView.isHidden = !self.isExpanded
            self.separatorView.isHidden = !self.isExpanded
        }
    }
}

// MARK: - Helper View for Detail Rows (Included in this file)
class PortfolioDetailRowView: UIView {
    private let titleLabel: UILabel
    private let valueLabel = UILabel(font: .systemFont(ofSize: 16), textAlignment: .right)
    
    init(title: String, titleFont: UIFont = .systemFont(ofSize: 16, weight: .medium)) {
        self.titleLabel = UILabel(text: title, font: titleFont, textColor: .darkGray)
        super.init(frame: .zero)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel], distribution: .fill)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(_ value: Double, percentage: Double? = nil) {
        let valueString: String
        if let percentage = percentage {
            let percentageSign = percentage >= 0 ? "+" : ""
            valueString = String(format: "%@ (%@%.2f%%)", value.toCurrency(), percentageSign, abs(percentage))
        } else {
            valueString = value.toCurrency()
        }
        valueLabel.text = valueString
        valueLabel.textColor = value >= 0 ? UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0) : .systemRed
    }
}
