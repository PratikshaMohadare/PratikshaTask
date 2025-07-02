//
//  HoldingTableViewCell.swift
//  PratikshaTask
//
//  Created by Pratiksha on 01/07/25.
//

import UIKit

class HoldingTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    private let topSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    private let symbolLabel = UILabel(font: .systemFont(ofSize: 16, weight: .bold))
    private let netQuantityLabel = UILabel(text: "NET QTY:", font: .systemFont(ofSize: 12), textColor: .darkGray)
    private let netQuantityValueLabel = UILabel(font: .systemFont(ofSize: 16, weight: .regular), textAlignment: .right)
    private let ltpTitleLabel = UILabel(text: "LTP:", font: .systemFont(ofSize: 12), textColor: .darkGray)
    private let ltpLabel = UILabel(font: .systemFont(ofSize: 16, weight: .regular), textAlignment: .right)
    private let profitAndLossLabel = UILabel(font: .systemFont(ofSize: 16, weight: .regular), textAlignment: .right)
    private let pnlTitleLabel = UILabel(text: "P&L:", font: .systemFont(ofSize: 12), textColor: .darkGray)

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(topSeparator)
        
        let netQtyStackView = UIStackView(arrangedSubviews: [netQuantityLabel, netQuantityValueLabel], spacing: 4)
        let leftStackView = UIStackView(arrangedSubviews: [symbolLabel, netQtyStackView], axis: .vertical, spacing: 4, alignment: .leading)
        
        let ltpStackView = UIStackView(arrangedSubviews: [ltpTitleLabel, ltpLabel], spacing: 4)
        let pnlStackView = UIStackView(arrangedSubviews: [pnlTitleLabel, profitAndLossLabel], spacing: 4)
        let rightVerticalStackView = UIStackView(arrangedSubviews: [ltpStackView, pnlStackView], axis: .vertical, spacing: 8, alignment: .trailing)
        
        let mainStackView = UIStackView(arrangedSubviews: [leftStackView, rightVerticalStackView], distribution: .fillEqually)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            topSeparator.topAnchor.constraint(equalTo: contentView.topAnchor),
            topSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            topSeparator.heightAnchor.constraint(equalToConstant: 1),
        
            mainStackView.topAnchor.constraint(equalTo: topSeparator.bottomAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Configuration
    func configure(with holding: Holding) {
        symbolLabel.text = holding.symbol.uppercased()
        netQuantityValueLabel.text = "\(holding.quantity)"
        ltpLabel.text = holding.ltp.toCurrency()
        
        let pnl = (holding.ltp - holding.avgPrice) * Double(holding.quantity)
        profitAndLossLabel.text = pnl.toCurrency()
        profitAndLossLabel.textColor = pnl >= 0 ? UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0) : .systemRed
    }
}

// MARK: - UI Element Extensions (for cleaner setup)
extension UILabel {
    convenience init(text: String? = nil, font: UIFont, textColor: UIColor = .black, textAlignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}

// MARK: - Refined Currency Formatter
extension Double {
    /// Formats a Double into a currency string (e.g., "₹1,234.56").
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let numberString = formatter.string(from: NSNumber(value: self)) ?? "0.00"
        return "₹" + numberString
    }
}
