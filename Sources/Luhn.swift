//
//  Luhn.swift
//  ANText
//
//  Created by Anton Novichenko on 3/16/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import Foundation

/// Validate a variety of identification numbers, such as credit card numbers
/// - Parameter string: String for validation
/// - Returns: `true` if string succesfully passed through algorithm 
func luhnAlgorithm(_ string: String) -> Bool {
	var sum = 0
	let reversedCharacters = string.reversed().map { String($0) }

	for (idx, element) in reversedCharacters.enumerated() {
		guard let digit = Int(element) else { return false }

		switch ((idx % 2 == 1), digit) {
		case (true, 9):
			sum += 9
		case (true, 0...8):
			sum += (digit * 2) % 9
		default:
			sum += digit
		}
	}

	return sum % 10 == 0
}
