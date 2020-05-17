//
//  Stringify+Optional.swift
//  Stringify
//
//  Created by Anton Novichenko on 5/17/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import Foundation

public protocol Default {
	static var defaultValue: Self { get }
}

public extension Optional where Wrapped: Default {
	/// Returns default value for every type that compatible with `Default` protocol and if its value is `nil`.
	var orEmpty: Wrapped {
		switch self {
		case .some(let value):
			return value
		default:
			return Wrapped.defaultValue
		}
	}
}

public extension Optional where Wrapped == String {
	/// Determine if the optional string is empty. Returns `true` if an optional string is nil.
	var isBlank: Bool {
		self?.isEmpty ?? true
	}
}

extension String: Default {
	public static var defaultValue: String {
		""
	}
}

extension Data: Default {
	public static var defaultValue: Data {
		Data()
	}
}
