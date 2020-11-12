# Stringify
A set of useful string extensions.

[![Version](https://img.shields.io/cocoapods/v/Stringify)](https://cocoapods.org/pods/Stringify)
[![License](https://img.shields.io/cocoapods/l/Stringify)](https://raw.githubusercontent.com/NovichenkoAnton/Stringify/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/Stringify)](https://cocoapods.org/pods/Stringify)

## Requirements

- iOS 10.0+
- Swift 5+

## Installation

### CocoaPods

Stringify is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'Stringify', '~> 1.0'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Stringify as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/NovichenkoAnton/Stringify.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

### String
1. Apply masks for the string in specific range. The range compatible with `CountableRange`, `ClosedRange`, `PartialRangeFrom`, `PartialRangeThrough`, `PartialRangeUpTo`.

```swift
let cardNumber = "1234567890123456"
let masked = cardNumber.maskSubstring(in: 6...13, with: "*")
print(masked!) //"123456********56"
```

2. Convert `String` to `Double`. If `String` is not compatible with `Double` the function will return 0.00.

``` swift
let amount = "100,12"
print(amount.toDouble()) //100.12

let anotherAmount = "1 200,10"
print(anotherAmount.toDouble()) //1200.1 
``` 

3. You can apply specific format for strings
```swift
let sum = "1234"
let formattedSum = sum.st.applyFormat(.sum)
print(formattedSum) //"1 234,00"
```

Supported formats
```swift
enum Format {
  case sum(minFractionDigits: Int = 2, maxFractionDigits: Int = 2)
  case creditCard
  case iban
  case custom(formatter: NumberFormatter)
}
```

4. Validate a number of credit card by Luhn algorithm.

5. Validate the string with specific pattern

```swift
"https://www.google.com".validate(with: .website) //true
```

6. Simple date formatter (from one format to another)

```swift
let dateTime = "2019-11-22 13:33"

let resultTime = dateTime.st.convertDate(from: "yyyy-MM-dd HH:mm", to: "h:mm") //"1:33"
```

7. Get query items from `String` that corresponds to `URL` type. Works for URLs with cyrillic domain names.

```swift
let stringURL = "https://test.com?foo=1&bar=abc"

let queryItems = stringURL.queryItems()! //["foo": "1", "bar": "abc"]
```

### NSMutableAttributedString
1. You can append two attributed strings with `+`

```swift
let part1 = "123"
let part2 = "456"

myLabel.attributedText = part1.attributed + part2.attributed
```

2. Apply attributes for mutable string

```swift
let string = "Some text"

label.attributedText = string.attributed.applyAttributes([
  .color(color: .red),
  .font(font: .systemFont(ofSize: 32, weight: .bold)),
  .crossed(width: 1, color: .black),
  .underline(style: .single, color: .blue)
])
```

![screenshot1](https://user-images.githubusercontent.com/8337067/77320216-38a66a00-6d21-11ea-8d1c-1ca8bf0bb9a7.png)

3. Apply styles for string

```swift
let sum = "1000,22"

label.attributedText = sum.attributed.applyStyle(.sum(integerAttrs: [
  .color(color: UIColor.red),
  .font(font: UIFont.systemFont(ofSize: 32, weight: .bold)),
  .underline(style: .double, color: .black)
], fractionAttrs: [
  .color(color: UIColor.green),
  .font(font: UIFont.systemFont(ofSize: 24, weight: .medium)),
], currencyMark: "$"))
```

![screenshot2](https://user-images.githubusercontent.com/8337067/77320368-7dca9c00-6d21-11ea-81fe-3e9162955fa2.png)
