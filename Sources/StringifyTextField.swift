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

    - **amount**: formatted text with sum type, e.g., "1 200,99"
	- **creditCard**: formatted text compatible with credit cards, e.g., "1234 5678 9012 3456"
	- **IBAN**: formatted text compatible with IBAN, e.g., "BY12 BLBB 1234 5678 0000 1234 5678"
	- **expDate**: expired date of credit cards, e.g., "03/22"
	*/
	public enum TextType: UInt {
		case amount = 0
		case creditCard = 1
		case IBAN = 2
		case expDate = 3
		case none = 4
	}

	// MARK: - IBInspectable

	@available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'textType' instead.")
	@IBInspectable var inputTextType: UInt {
		get {
			textType.rawValue
		}
		set {
			textType = StringifyTextField.TextType(rawValue: min(newValue, 4)) ?? .none
		}
	}

	/// Currency mark for `.amount` type
	@IBInspectable public var currencyMark: String = ""
	/// Use decimal separator or not. Only for `.amount` type
	@IBInspectable public var decimal: Bool = true {
		didSet {
			if textType == .amount {
				configureDecimalFormat()
			}
		}
	}
	/// Decimal separator between integer and fraction parts. Only for `.amount` type
	@IBInspectable public var decimalSeparator: String = "," {
		didSet {
			numberFormatter.decimalSeparator = decimalSeparator
		}
	}
	///Maximum digits for integer part of amount
	@IBInspectable public var maxIntegerDigits: UInt = 10

	// MARK: - Public properties

	/// Specific `TextType` for formatting text in textfield
	public var textType: TextType = .amount {
		didSet {
			configure()
		}
	}

	// MARK: - Private properties

	private lazy var numberFormatter = NumberFormatter()

	// MARK: - Public properties

	///Computed property for getting clean value (without inner whitespaces)
	public var associatedValue: String {
		switch textType {
		case .amount:
			return cleanValueForSum()
		case .creditCard:
			return cleanValue()
		case .IBAN:
			return cleanValue().uppercased()
		case .expDate:
			return expDateCleanValue()
		default:
			return text!
		}
	}

	// MARK: - Inits
	public init(type inputType: TextType) {
		self.textType = inputType

		super.init(frame: .zero)

		configure()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)

		configure()
	}

	// MARK: - Functions
	private func configure() {
		delegate = self

		switch textType {
		case .amount:
			numberFormatter.groupingSeparator = " "
			numberFormatter.numberStyle = .decimal

			configureDecimalFormat()
		case .creditCard, .expDate:
			keyboardType = .numberPad
		case .IBAN:
			keyboardType = .asciiCapable
			autocapitalizationType = .allCharacters
			autocorrectionType = .no
			returnKeyType = .done
		case .none:
			keyboardType = .default
		}
	}

	private func configureDecimalFormat() {
		if decimal {
			keyboardType = .decimalPad

			numberFormatter.decimalSeparator = decimalSeparator
			numberFormatter.maximumFractionDigits = 2
		} else {
			keyboardType = .numberPad
		}
	}

	public override func closestPosition(to point: CGPoint) -> UITextPosition? {
		switch textType {
		case .amount:
			return position(from: beginningOfDocument, offset: self.text?.count ?? 0)
		default:
			return super.closestPosition(to: point)
		}
	}

	public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		switch textType {
		case .amount, .expDate:
			if action == #selector(paste(_:)) || action == #selector(cut(_:)) {
				return false
			}
			return super.canPerformAction(action, withSender: sender)
		default:
			return super.canPerformAction(action, withSender: sender)
		}
	}

	public override func paste(_ sender: Any?) {
		guard UIPasteboard.general.hasStrings, var pastedString = UIPasteboard.general.string else {
			return
		}

		pastedString = pastedString.replacingOccurrences(of: " ", with: "")

		switch textType {
		case .creditCard:
			if pastedString.hasOnlyDigits(), pastedString.count <= 16 {
				self.text = pastedString.separate(every: 4, with: " ")
			}
		case .IBAN:
			if pastedString.count <= 34 {
				self.text = pastedString.separate(every: 4, with: " ")
			}
		default:
			super.paste(sender)
		}
	}
}

// MARK: - Private extension (.amount format)
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

	func shouldChangeSumText(in range: NSRange, with string: String, and text: String) -> Bool {
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

// MARK: - Private extension (.creditCard, .IBAN formats)
private extension StringifyTextField {
	func cleanValue() -> String {
		self.text!.replacingOccurrences(of: " ", with: "").trim()
	}

	func shouldChangeText(in range: NSRange, with string: String, and text: String, with maxLength: Int) -> Bool {
		if string.isEmpty {
			return true
		}

		let cursorLocation = position(from: beginningOfDocument, offset: (range.location + NSString(string: string).length))

		let possibleText = (text as NSString).replacingCharacters(in: range, with: string)

		if possibleText.count <= maxLength {
			self.text = possibleText.replacingOccurrences(of: " ", with: "").separate(every: 4, with: " ")
		}

		if let location = cursorLocation {
			selectedTextRange = textRange(from: location, to: location)
		}

		return false
	}
}

// MARK: - Private extension (.expDate format)
private extension StringifyTextField {
	func expDateCleanValue() -> String {
		self.text!.replacingOccurrences(of: "/", with: "").trim()
	}

	func shouldChangeExpDate(in range: NSRange, with string: String, and text: String) -> Bool {
		if string.isEmpty {
			return true
		}

		let cursorLocation = position(from: beginningOfDocument, offset: (range.location + NSString(string: string).length))

		let possibleText = (text as NSString).replacingCharacters(in: range, with: string)

		if possibleText.count == 2 {
			self.text = possibleText + "/"
		} else if possibleText.count <= 5 {
			self.text = possibleText.replacingOccurrences(of: "/", with: "").separate(every: 2, with: "/")
		}

		if let location = cursorLocation {
			selectedTextRange = textRange(from: location, to: location)
		}

		return false
	}
}

// MARK: - UITextFieldDelegate
extension StringifyTextField: UITextFieldDelegate {
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		guard let text = textField.text, !text.isEmpty else { return }

		switch textType {
		case .amount:
			applySumFormat()
		default:
			break
		}
	}

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let text = textField.text else { return false }

		switch textType {
		case .amount:
			return shouldChangeSumText(in: range, with: string, and: text)
		case .creditCard:
			return shouldChangeText(in: range, with: string, and: text, with: 19)
		case .IBAN:
			return shouldChangeText(in: range, with: string, and: text, with: 42)
		case .expDate:
			return shouldChangeExpDate(in: range, with: string, and: text)
		default:
			return true
		}
	}

	public func textFieldDidEndEditing(_ textField: UITextField) {
		guard let text = textField.text, !text.isEmpty else { return }

		switch textType {
		case .amount:
			sumFormatEnding()
		default:
			break
		}
	}

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return resignFirstResponder()
	}
}
