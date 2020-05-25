//
//  Stringify.swift
//  Stringify
//
//  Created by Anton Novichenko on 3/12/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import Foundation

public protocol StringifyCompatible {
	associatedtype CompatibleType

	static var st: Stringify<CompatibleType>.Type { get set }
	var st: Stringify<CompatibleType> { get set }
}

public class Stringify<Base> {
	let st: Base

	init(_ st: Base) {
		self.st = st
	}

	lazy var triadNumberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.decimalSeparator = ","
		formatter.groupingSeparator = " "
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}()

	lazy var dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .iso8601)
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter
	}()
}

public extension StringifyCompatible {
	static var st: Stringify<Self>.Type {
		get { Stringify<Self>.self }
		set {}
	}

	var st: Stringify<Self> {
		get { Stringify(self) }
		set {}
	}
}
