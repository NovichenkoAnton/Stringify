# Stringify
A set of useful string extensions

[![Version](https://img.shields.io/cocoapods/v/Stringify)](https://cocoapods.org/pods/Stringify)
[![License](https://img.shields.io/cocoapods/l/Stringify)](https://raw.githubusercontent.com/NovichenkoAnton/Stringify/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/Stringify)](https://cocoapods.org/pods/Stringify)

## Requirements

- iOS 10

## Installation

```ruby
pod 'Stringify', '~> 1.0'
```

## Future plans
- [ ] Date formatting
- [ ] Styling `NSMutableAttributedString`s with a range

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

6. Simple date formatter (from one format to another)

```swift
let dateTime = "2019-11-22 13:33"

let resultTime = try! dateTime.st.convertDate(from: "yyyy-MM-dd HH:mm", to: "h:mm") //"1:33"
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


# StringifyTextField

`StringifyTextField` is a textfield which can format inputed string with 3 available formats.

## Usage

```swift
import Stringify

//Connect IBOutlet
@IBOutlet var stringifyTextField: StringifyTextField!

//Create programmatically
let manualTextField = StringifyTextField(type: .amount)
manualTextField.frame = CGRect(x: 20, y: 100, width: 200, height: 40)
```

Available formats:
```swift
public enum TextType: UInt {
  case amount = 0
  case creditCard = 1
  case IBAN = 2
}
```

### Amount format

You can specify currency mark for `.amount` text type

![currency mark](https://user-images.githubusercontent.com/8337067/77302043-bc505e80-6d01-11ea-95c0-1e3af86a8cc0.gif)

Set up maximum integer digits (if your amount contains integer and fraction parts).

```swift
stringifyTextField.maxIntegerDigits = 6
```

If your amount doesn't contain a fraction part, you can disable `decimal` through Interface Builder or programmatically.

```swift
stringifyTextField.decimal = false
```

### Credit card format

![credit card format](https://user-images.githubusercontent.com/8337067/77302097-d7bb6980-6d01-11ea-87ef-6c64f2f75abe.gif)

### Exp date format

![exp date format](https://user-images.githubusercontent.com/8337067/77651967-9a174480-6f7e-11ea-947c-de74b8a40804.gif)

You can specify date format to get needed "clean" value

```swift
stringifyTextField.dateFormat = "MM.yyyy"
```

### Clean value

You can get "clean" value from `StringifyTextField`, e.g for `.expDate` format it will be value with applying specific date format.

```swift
let expDate = stringifyTextField.associatedValue
```

## Demo
You can see other features in the example project.
