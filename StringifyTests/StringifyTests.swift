//
//  StringifyTests.swift
//  StringifyTests
//
//  Created by Anton Novichenko on 3/12/20.
//  Copyright © 2020 Anton Novichenko. All rights reserved.
//

import XCTest
import Stringify

final class StringifyTests: XCTestCase {

	private var numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.decimalSeparator = "."
		formatter.maximumFractionDigits = 0
		formatter.roundingMode = .down
		return formatter
	}()

	private let ownPattern = "^[a-zA-Z0-9]+$"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testDouble() {
		let double1 = "123,11"
		let double2 = "123"
		let double3 = "123.11"
		let double4 = "0,01"
		let double5 = "test"
		let double6 = ""
		let double7 = "1 200,10"

		let result1 = double1.toDouble()
		XCTAssertEqual(result1, 123.11)

		let result2 = double2.toDouble()
		XCTAssertEqual(result2, 123)

		let result3 = double3.toDouble()
		XCTAssertEqual(result3, 123.11)

		let result4 = double4.toDouble()
		XCTAssertEqual(result4, 0.01)

		let result5 = double5.toDouble()
		XCTAssertEqual(result5, 0.00)

		let result6 = double6.toDouble()
		XCTAssertEqual(result6, 0.00)

		let result7 = double7.toDouble()
		XCTAssertEqual(result7, 1200.1)
	}

	func testTriadFormat() {
		let string1 = "1234"
		let string2 = "1 234"
		let string3 = "1 234,56"
		let string4 = "1 234.56"
		let string5 = "0,01"
		let string6 = "0.01"
		let string7 = "test text"
		let string8 = "0"
		let string9 = ""
		let string10 = "1234,5499999999"

		let result1 = string1.st.applyFormat(.sum())
		XCTAssertEqual(result1, "1 234,00")

		let result2 = string2.st.applyFormat(.sum())
		XCTAssertEqual(result2, "1 234,00")

		let result3 = string3.st.applyFormat(.sum())
		XCTAssertEqual(result3, "1 234,56")

		let result4 = string4.st.applyFormat(.sum())
		XCTAssertEqual(result4, "1 234,56")

		let result5 = string5.st.applyFormat(.sum())
		XCTAssertEqual(result5, "0,01")

		let result6 = string6.st.applyFormat(.sum())
		XCTAssertEqual(result6, "0,01")

		let result7 = string7.st.applyFormat(.sum())
		XCTAssertEqual(result7, "0,00")

		let result8 = string8.st.applyFormat(.sum())
		XCTAssertEqual(result8, "0,00")

		let result9 = string9.st.applyFormat(.sum())
		XCTAssertEqual(result9, "0,00")

		let result11 = string9.st.applyFormat(.sum(fractionDigits: 0))
		XCTAssertEqual(result11, "0")

		let result10 = string10.st.applyFormat(.sum())
		XCTAssertEqual(result10, "1 234,55")
	}

	func testSeparate() {
		let string1 = "1234567890123456"
		let string2 = ""
		let string3 = "123"
		let string4 = "1111222233334444555566667777"
		let string5 = "11112222333344"

		//Test separate through 4 symbols
		let result1 = string1.separate()
		XCTAssertEqual(result1, "1234 5678 9012 3456")

		let result2 = string2.separate()
		XCTAssertEqual(result2, "")

		let result3 = string3.separate()
		XCTAssertEqual(result3, "123")

		let result4 = string4.separate()
		XCTAssertEqual(result4, "1111 2222 3333 4444 5555 6666 7777")

		let result5 = string5.separate()
		XCTAssertEqual(result5, "1111 2222 3333 44")

		//Test separate through 4 symbols with :
		let result6 = string1.separate(every: 2, with: ":")
		XCTAssertEqual(result6, "12:34:56:78:90:12:34:56")

		let result7 = string2.separate(every: 2, with: ":")
		XCTAssertEqual(result7, "")

		let result8 = string3.separate(every: 2, with: ":")
		XCTAssertEqual(result8, "12:3")

		let result9 = string4.separate(every: 2, with: ":")
		XCTAssertEqual(result9, "11:11:22:22:33:33:44:44:55:55:66:66:77:77")

		let result10 = string5.separate(every: 2, with: ":")
		XCTAssertEqual(result10, "11:11:22:22:33:33:44")
	}

	func testLuhnAlgo() {
		let string1 = "123"
		let string2 = "79927398713"
		let string3 = "5578 8549 6021 0681"

		XCTAssertFalse(string1.validateCreditCard())

		let result2 = string2.validateCreditCard()
		XCTAssertTrue(result2)

		let result3 = string3.validateCreditCard()
		XCTAssertTrue(result3)
	}

	func testCardFormat() {
		let string1 = "1234567890123456"

		let result1 = string1.st.applyFormat(.creditCard)
		XCTAssertEqual(result1, "1234 5678 9012 3456")
	}

	func testIbanFormat() {
		let string1 = "AD1200012030200359100100"

		let result1 = string1.st.applyFormat(.iban)
		XCTAssertEqual(result1, "AD12 0001 2030 2003 5910 0100")
	}

	func testCustomFormat() {
		let string1 = "1234"
		let string2 = "1 234"
		let string3 = "1 234,56"
		let string4 = "1 234.56"
		let string5 = "0,01"
		let string6 = "0.01"
		let string7 = "test text"
		let string8 = "0"
		let string9 = ""

		let result1 = string1.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result1, "1234")

		let result2 = string2.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result2, "1234")

		let result3 = string3.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result3, "1234")

		let result4 = string4.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result4, "1234")

		let result5 = string5.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result5, "0")

		let result6 = string6.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result6, "0")

		let result7 = string7.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result7, "0")

		let result8 = string8.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result8, "0")

		let result9 = string9.st.applyFormat(.custom(formatter: numberFormatter))
		XCTAssertEqual(result9, "0")
	}

	func textClean() {
		let string1 = "1234"
		let string2 = "1 234"
		let string3 = "1 234,56"
		let string4 = "1 234.56"
		let string5 = "0,01"
		let string6 = "0.01"
		let string7 = "test text"
		let string8 = "0"
		let string9 = ""

		let result1 = string1.st.clean()
		XCTAssertEqual(result1, "1234")

		let result2 = string2.st.clean()
		XCTAssertEqual(result2, "1234")

		let result3 = string3.st.clean()
		XCTAssertEqual(result3, "1234.56")

		let result4 = string4.st.clean()
		XCTAssertEqual(result4, "1234.56")

		let result5 = string5.st.clean()
		XCTAssertEqual(result5, "0.01")

		let result6 = string6.st.clean()
		XCTAssertEqual(result6, "0.01")

		let result7 = string7.st.clean()
		XCTAssertEqual(result7, "0.00")

		let result8 = string8.st.clean()
		XCTAssertEqual(result8, "0.00")

		let result9 = string9.st.clean()
		XCTAssertEqual(result9, "0.00")
	}

	func testMaksSubstring() {
		let string1 = "abcdefg"

		//CountabeRange
		XCTAssertNil(string1.maskSubstring(in: 1..<10, with: "*"))

		let result2 = string1.maskSubstring(in: 5..<7, with: "*")
		XCTAssertEqual(result2, "abcde**")

		//ClosedRange
		XCTAssertNil(string1.maskSubstring(in: 5...7, with: "*"))

		let result3 = string1.maskSubstring(in: 5...6, with: "*")
		XCTAssertEqual(result3, "abcde**")

		//PartialRangeFrom
		let result4 = string1.maskSubstring(in: 5..., with: "*")
		XCTAssertEqual(result4, "abcde**")

		let result5 = string1.maskSubstring(in: 6..., with: "*")
		XCTAssertEqual(result5, "abcdef*")

		XCTAssertNil(string1.maskSubstring(in: 7..., with: "*"))

		//PartialRangeThrough
		let result6 = string1.maskSubstring(in: ...2, with: "*")
		XCTAssertEqual(result6, "***defg")

		let result7 = string1.maskSubstring(in: ...6, with: "*")
		XCTAssertEqual(result7, "*******")

		XCTAssertNil(string1.maskSubstring(in: ...7, with: "*"))

		//PartialRangeUpTo
		let result8 = string1.maskSubstring(in: ..<2, with: "*")
		XCTAssertEqual(result8, "**cdefg")

		let result9 = string1.maskSubstring(in: ..<6, with: "*")
		XCTAssertEqual(result9, "******g")

		let result10 = string1.maskSubstring(in: ..<7, with: "*")
		XCTAssertEqual(result10, "*******")

		XCTAssertNil(string1.maskSubstring(in: ..<8, with: "*"))
	}

	func testValidate() {
		//selection
		let string1 = "+375291112233"
		let string2 = "375291112233"
		let string3 = "test@test.com"
		let string4 = "https://www.google.com"
		let string5 = "www.google.com"
		let string6 = "google.com"
		let string7 = "googlecom"
		let string8 = "123abc"

		let result1 = string1.validate(with: .phoneBY)
		XCTAssertTrue(result1)

		let result2 = string2.validate(with: .phoneBY)
		XCTAssertFalse(result2)

		let result3 = string3.validate(with: .email)
		XCTAssertTrue(result3)

		let result4 = string4.validate(with: .website)
		XCTAssertTrue(result4)

		let result5 = string5.validate(with: .website)
		XCTAssertTrue(result5)

		let result6 = string6.validate(with: .website)
		XCTAssertTrue(result6)

		let result7 = string7.validate(with: .website)
		XCTAssertFalse(result7)

		let result8 = string8.validate(with: .own(pattern: ownPattern))
		XCTAssertTrue(result8)
	}

	func testSize() {
		let string1 = "123321"
		let string2 = ""

		let result1 = string1.size(width: UIScreen.main.bounds.width)
		XCTAssertGreaterThan(result1.height, 0)
		let result2 = string2.size(width: UIScreen.main.bounds.width)
		XCTAssertEqual(result2.height, 0)
	}

	func testAttributedString() {
		let string1 = "123123"
		let part1 = "123"
		let part2 = "321"

		let resutl1 = string1.attributed.applyAttributes(
			[
				.color(color: .red),
				.font(font: .systemFont(ofSize: 13)),
				.own(attrs: [.strikethroughStyle: 1])
			]
		)

		XCTAssert(resutl1.attribute(.font, at: 0, effectiveRange: nil) != nil)
		XCTAssert(resutl1.attribute(.foregroundColor, at: 0, effectiveRange: nil) != nil)
		XCTAssert(resutl1.attribute(.strikethroughStyle, at: 0, effectiveRange: nil) != nil)

		let result2 = part1.attributed + part2.attributed
		XCTAssertEqual(result2.string, "123321")
	}

	func testAttributedSum() {
		let string1 = "12333,33"
		let string2 = "12333.33"

		let result1 = string1.attributed.applyStyle(.sum(integerAttrs:
			[
				.color(color: UIColor.red)
			],
			fractionAttrs:
			[
				.color(color: UIColor.yellow)
			], currencyMark: "$"))
		XCTAssertEqual(result1.string, "12 333,33$")

		let result2 = string2.attributed.applyStyle(.sum())
		XCTAssertEqual(result2.string, "12 333,33")
	}

	func testConvertDates() {
		let dateTime1 = "2019-11-22 13:33"
		let dateTime2 = "2019-11-22 13:33"

		let result1 = dateTime1.st.convertDate(from: "yyyy-MM-dd HH:mm", to: "h:mm")
		XCTAssertEqual(result1, "1:33")

		let result2 = dateTime2.st.convertDate(from: "yyyy-MM-dd HH:mm", to: "HH:mm")
		XCTAssertEqual(result2, "13:33")

		XCTAssertNil(dateTime1.st.convertDate(from: "yyyy-MM-dd", to: "HH:mm"))
	}

	func testHasOnlyDigits() {
		let string1 = "123456"
		let string2 = "123a56"
		let string3 = " "
		let string4 = ""

		XCTAssertTrue(string1.hasOnlyDigits())
		XCTAssertFalse(string2.hasOnlyDigits())
		XCTAssertFalse(string3.hasOnlyDigits())
		XCTAssertFalse(string4.hasOnlyDigits())
	}

	func testQueryItems() {
		let url1 = "https://test.com?foo=1&bar=abc"
		let url2 = "https://test.com"
		let url3 = "https://абв.бел?foo=2"
		let url4 = "https://абв.бел/город?foo=3"
		let url5 = "https://test.com/город?foo=4"
		let url6 = "https://test.com?foo=%D0%B0%D0%B1%D0%B2"

		if let queryItems1 = url1.queryItems() {
			XCTAssertEqual(queryItems1["foo"], "1")
			XCTAssertEqual(queryItems1["bar"], "abc")
		}

		if let queryItems2 = url2.queryItems() {
			XCTAssertTrue(queryItems2.isEmpty)
		}

		if let queryItems3 = url3.queryItems() {
			XCTAssertEqual(queryItems3["foo"], "2")
		}

		if let queryItems4 = url4.queryItems() {
			XCTAssertEqual(queryItems4["foo"], "3")
		}

		if let queryItems5 = url5.queryItems() {
			XCTAssertEqual(queryItems5["foo"], "4")
		}

		if let quertyItems6 = url6.queryItems() {
			XCTAssertEqual(quertyItems6["foo"], "абв")
		}
	}

	func testOptionalString() {
		let string1: String? = nil
		let string2: String? = "abc"

		XCTAssertEqual(string1.isBlank, true)
		XCTAssertEqual(string1.orEmpty, "")
		XCTAssertEqual(string2.isBlank, false)
		XCTAssertEqual(string2.orEmpty, "abc")
	}

	func testData() {
		let string1 = "abc"
		let string2: String? = nil
		let string3 = "абв"

		XCTAssertEqual(string1.data.count, 3)
		XCTAssertEqual(string2.orEmpty.data, Data())
		XCTAssertEqual(string3.data.count, 6)
	}
}
