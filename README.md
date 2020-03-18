# Stringify
A set of usefull string extensions

[![Version](https://img.shields.io/cocoapods/v/Stringify)](https://cocoapods.org/pods/Stringify)
[![License](https://img.shields.io/cocoapods/l/Stringify)](https://cocoapods.org/pods/Alidade)
[![Platform](https://img.shields.io/cocoapods/p/Stringify)](https://cocoapods.org/pods/Stringify)

## Installation

```ruby
pod 'Stringify', '~> 0.1'
```

## Future plans
- [ ] Date formatting
- [ ] Styling `NSMutableAttributedString`s with range

## Usage

### String
1. Apply masks for the string in specific range. The range compatible with `CountableRange`, `ClosedRange`, `PartialRangeFrom`, `PartialRangeThrough`, `PartialRangeUpTo`.

```swift
let cardNumber = "1234567890123456"
let masked = try! cardNumber.maskSubstring(in: 6...13, with: "*")
print(masked) //"123456********56"
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
let formattedSum = sum.st.applyFormat(.sum())
print(formattedSum) //"1 234,00"
```

Supported formats
```swift
enum Format {
  case sum(minFractionDigist: Int = 2)
  case creditCard
  case iban
  case custom(formatter: NumberFormatter)
}
```

4. Validate a number of credit card by Luhn algorithm.

5. Validate you string with specific pattern

```swift
"https://www.google.com".validate(with: .website) //true
```

### NSMutableAttributedString
1. You can append tho attributed strings with `+`

```swift
let part1 = "123"
let part2 = "456"

myLable.attributedText = part1.attributed + part2.attributed
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

<img src="/Screenshots/screenshot2.png" width="200">

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

<img src="/Screenshots/screenshot1.png" width="200">
