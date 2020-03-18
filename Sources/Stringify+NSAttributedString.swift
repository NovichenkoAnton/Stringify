//
//  Stringify+NSAtrributedString.swift
//  Stringify
//
//  Created by Anton Novichenko on 3/16/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit

public extension NSMutableAttributedString {
	/** Concatinate two attributed strings

		//You can use it with `String` extension
		let result = "123".attributed + "321".attributed
		print(result) // "123321"

	- Parameters:
		- lhs: First attributed string
		- rhs: Second attributed string
	- Returns: Concatinated attributed string
	*/
	static func + (lhs: NSMutableAttributedString, rhs: NSMutableAttributedString) -> NSMutableAttributedString {
		let resultString = NSMutableAttributedString()
		resultString.append(lhs)
		resultString.append(rhs)
		return resultString
	}

	/** Custom attributes for `NSMutableAttributedString`

	- **color**: foregorund color for the string
	- **font**: `UIFont` for the string
	- **crossed**: setup crossed out string with width and color
	- **underline**: apply underline style for the string
	- **url**: setup a link for the string
	- **own**: own attributes for the string
	*/
	enum Attrs {
		case color(color: UIColor = UIColor.black)
		case font(font: UIFont = UIFont.systemFont(ofSize: 16))
		case crossed(width: Int, color: UIColor = UIColor.black)
		case underline(style: NSUnderlineStyle = NSUnderlineStyle.single, color: UIColor = UIColor.black)
		case url(url: String)
		case own(attrs: [NSAttributedString.Key : Any] = [:])
	}

	enum Style {
		case sum(integerAttrs: [Attrs] = [], fractionAttrs: [Attrs] = [], currencyMark: String = "")
	}

	/** Apply own attributes for `NSMutableAttributedString`

		//You can use this function for ordinary string, for example:
		let attrString = "123123".attributed.applyAttributes(/*...*/)

	- Parameter attributes: Array of attributes for creating `NSMutableAttributedString`
	- Returns: `NSMutableAttributedString` with attributes applied
	*/
	func applyAttributes(_ attributes: [Attrs]) -> NSMutableAttributedString {
		let range = NSRange(location: 0, length: self.length)

		for attr in attributes {
			switch attr {
			case let .color(color):
				self.addAttribute(.foregroundColor, value: color, range: range)
			case let .font(font):
				self.addAttribute(.font, value: font, range: range)
			case let .crossed(width, color):
				self.addAttribute(.strikethroughStyle, value: width, range: range)
				self.addAttribute(.strikethroughColor, value: color, range: range)
			case let .underline(style, color):
				self.addAttribute(.underlineStyle, value: style.rawValue, range: range)
				self.addAttribute(.underlineColor, value: color, range: range)
			case let .url(url):
				if let link = NSURL(string: url) {
					self.addAttribute(.link, value: link, range: range)
				}
			case let .own(attrs):
				self.addAttributes(attrs, range: range)
			}
		}

		return self
	}

	/** Apply style for specific string with specific `Style`

		let result1 = "12333,33".attributed.applyStyle(.sum(integerAttrs:
		[
		  .color(color: UIColor.red)
		],
		fractionAttrs:
		[
		  .color(color: UIColor.yellow)
		], currencyMark: "$"))
		print(result1) //12 333,33$

	- Parameter style: `Style` for formatting
	- Returns: Fromatted attributted string
	*/
	func applyStyle(_ style: Style) -> NSMutableAttributedString {
		switch style {
		case let .sum(integerAttrs, fractionAttrs, currencyMark):
			return attributeSum(integerAttrs: integerAttrs, fractionAttrs: fractionAttrs, currencyMark: currencyMark)
		}
	}

	/** Create an attributed string with an amount style with attributes for integer part and fraction part of the string. A devider is styled with fraction attributes, a currency mark is styled with attributes for fraction part, if fraction attributes are empty, the currency mark will be styed with attributes for integer part.


	- Parameters:
	  - integerAttrs: Attributes for integer part
	  - fractionAttrs: Attributes for fraction part
	  - currencyMark: Currency mark if needed
	- Returns: Formatted `NSMutableAttributedString`
	*/
	private func attributeSum(integerAttrs: [Attrs], fractionAttrs: [Attrs], currencyMark: String) -> NSMutableAttributedString {
		var currency = NSMutableAttributedString(string: currencyMark)

		let parts = self.string.st.applyFormat(.sum()).components(separatedBy: defaultSeparator.string)
		let integerPart = parts.first ?? ""
		let fractionPart = parts.last ?? ""

		var integerAttributed = NSMutableAttributedString(string: integerPart)
		var fractionAttributed = NSMutableAttributedString(string: fractionPart)

		if !integerPart.isEmpty && !integerAttrs.isEmpty {
			integerAttributed = integerPart.attributed.applyAttributes(integerAttrs)
		}

		if !fractionPart.isEmpty && !fractionAttrs.isEmpty {
			fractionAttributed = fractionPart.attributed.applyAttributes(fractionAttrs)
		}

		let separator = defaultSeparator.applyAttributes(fractionAttrs)
		currency = currencyMark.trim().attributed.applyAttributes(fractionAttrs)

		return integerAttributed + separator + fractionAttributed + currency
	}
}

private extension NSMutableAttributedString {
	/// Possible separators for amount strings
	private var separators: CharacterSet {
		CharacterSet(charactersIn: ",.")
	}

	/// Default separator for sum strings
	private var defaultSeparator: NSMutableAttributedString {
		",".attributed
	}
}
