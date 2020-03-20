//
//  StringifyTextField.swift
//  Stringify
//
//  Created by Anton Novichenko on 3/18/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit

public class StringifyTextField: UITextField {
	/**
	Possible text types for `StringifyTextField`

    - **sum**: formatted text with sum type, for example, "1 200,99"
	- **creditCard**: formatted text compatible with credit cards, for example, "1234 5678 9012 3456"
	- **IBAN**: formatted text compatible with IBAN, for example, "BY12 BLBB 1234 5678 0000 1234 5678"
	*/
	private enum TextType: UInt {
		case sum = 0
		case creditCard = 1
		case IBAN = 2
		case none = 3
	}

	// MARK: - IBInspectable

	@IBInspectable var textType: UInt {
		get {
			_textType.rawValue
		}
		set {
			_textType = StringifyTextField.TextType(rawValue: min(newValue, 3)) ?? .none
		}
	}

	/// Currency mark for `.sum` type
	@IBInspectable var currencyMark: String = ""
	/// Use decimal separator or not. Only for `.sum` type
	@IBInspectable var decimal: Bool = true
	/// Decimal separator between integer and fraction parts. Only for `.sum` type
	@IBInspectable var decimalSeparator: String = ","
	///Maximum digits for integer part of sum
	@IBInspectable var maxIntegerDigits: UInt = 10

	// MARK: - Private properties

	private var _textType: TextType = .sum

	private lazy var numberFormatter = NumberFormatter()

	// MARK: - Public properties

	///Computed property for getting clean value (without inner whitespaces)
	public var associatedValue: String {
		switch _textType {
		case .sum:
			return cleanValueForSum()
		default:
			return text!
		}
	}

	// MARK: - Functions
	public override func awakeFromNib() {
		super.awakeFromNib()

		delegate = self

		configure()
	}

	private func configure() {
		switch _textType {
		case .sum:
			numberFormatter.groupingSeparator = " "
			numberFormatter.numberStyle = .decimal

			if decimal {
				keyboardType = .decimalPad

				numberFormatter.decimalSeparator = decimalSeparator
				numberFormatter.maximumFractionDigits = 2
			} else {
				keyboardType = .numberPad
			}
		case .creditCard:
			keyboardType = .numberPad
		case .IBAN:
			keyboardType = .asciiCapable
			autocapitalizationType = .allCharacters
		case .none:
			keyboardType = .default
		}
	}

	public override func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)

		addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
		addTarget(self, action: #selector(textFiledDidEndOnExit), for: .editingDidEndOnExit)
		addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
	}

	public override func closestPosition(to point: CGPoint) -> UITextPosition? {
		switch _textType {
		case .sum:
			return position(from: beginningOfDocument, offset: self.text?.count ?? 0)
		default:
			return super.closestPosition(to: point)
		}
	}

	public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		switch _textType {
		case .sum:
			if action == #selector(paste(_:)) || action == #selector(cut(_:)) {
				return false
			}
			return super.canPerformAction(action, withSender: sender)
		default:
			return super.canPerformAction(action, withSender: sender)
		}
	}

	// MARK: - Events
	@objc func textFieldDidBeginEditing() {
		guard let text = text, !text.isEmpty else { return }

		switch _textType {
		case .sum:
			applySumFormat()
		default:
			break
		}
	}

	@objc func textFiledDidEndOnExit() {}

	@objc func textFieldDidEndEditing() {
		guard let text = text, !text.isEmpty else { return }

		switch _textType {
		case .sum:
			sumFormatEnding()
		default:
			break
		}
	}
}

// MARK: - Private extension (.sum format)
private extension StringifyTextField {
	enum InputedCharacter {
		case number
		case separator
	}

	func applySumFormat() {
		if !currencyMark.isEmpty {
			self.text = self.text!.replacingOccurrences(of: currencyMark, with: "").trim()
		}
	}

	func sumFormatEnding() {
		self.text = "\(self.text!.st.applyFormat(.custom(formatter: numberFormatter))) \(currencyMark)".trim()
	}

	func cleanValueForSum() -> String {
		var textWithoutCurrency = self.text!.trim()

		if !currencyMark.isEmpty {
			textWithoutCurrency = textWithoutCurrency.replacingOccurrences(of: currencyMark, with: "")
		}

		if decimal {
			return textWithoutCurrency.st.clean()
		} else {
			return textWithoutCurrency.replacingOccurrences(of: " ", with: "")
		}
	}

	func shouldChangeSumText(in range: NSRange, with string: String, for text: String) -> Bool {
		//Removing characters
		if string.isEmpty {
			if text.count > 1 {
				let possibleText = String(text.dropLast())

				if let lastCharacter = possibleText.last, String(lastCharacter) == decimalSeparator {
					self.text = possibleText
				} else {
					self.text = possibleText.st.applyFormat(.custom(formatter: numberFormatter))
				}

				return false
			} else {
				return true
			}
		}

		//Format inputed characters
		let adjustedInputedCharacter: InputedCharacter

		if string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
			adjustedInputedCharacter = .number
		} else {
			adjustedInputedCharacter = .separator
		}

		if adjustedInputedCharacter == .separator && !text.contains(decimalSeparator) {
			self.text = text + decimalSeparator
		} else if adjustedInputedCharacter == .number {
			let possibleText = text + string

			let amountParts = possibleText.components(separatedBy: decimalSeparator)

			if amountParts.count == 2 {
				if let fraction = amountParts.last, fraction.count > 2 {
					self.text = text
				} else {
					return true
				}
			} else {
				guard possibleText.st.clean(fractionDigits: 0).count <= maxIntegerDigits else {
					return false
				}

				self.text = possibleText.st.applyFormat(.custom(formatter: numberFormatter))
			}
		}

		return false
	}
}

// MARK: - UITextFieldDelegate
extension StringifyTextField: UITextFieldDelegate {
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		switch _textType {
		case .sum:
			guard let text = textField.text else { return false }

			return shouldChangeSumText(in: range, with: string, for: text)
		case .creditCard:
			guard let text = textField.text else { return false }

			return true
		default:
			return true
		}
	}
}
