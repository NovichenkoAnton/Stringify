//
//  UIColor.swift
//  Stringify
//
//  Created by Anton Novichenko on 11/12/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import UIKit

public extension UIColor {
	/// Make hex-string from color
	var hexString: String {
		let cgColorInRGB = cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)

		if let components = cgColorInRGB?.components {
			let r = components[0]
			let g = components[1]
			let b = (components.count > 2) ? components[2] : g
			let a = cgColor.alpha
			
			var hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))

			if a < 1 {
				hexString += String(format: "%02lX", lroundf(Float(a * 255)))
			}

			return hexString
		}
		
		return ""
	}
}
