# DJEncoding

Provides implementations of `Encoder` and `Decoder`, which I created for personal use.

_Be aware, that this is a very early release, which "works for me" for the moment._

## CSVEncoder & CSVDecoder

Provides `CSVEncoder` and `CSVDecoder` following the example set by `JSONEncoder` and `JSONDecoder`. They allow encoding and decoding of CSV-files.

### Usage

* Instantiate a `CSVEncoder` or `CSVDecoder`.
* Optionally configure options via methods on <instance>.configuration _(currently only supported by `CSVDecoder`.)_
* Use methods of `Encoder` / `Decoder`

### Example: Decoding

The CSV-file:

```plain
"name";"age";"doesLikeBurgers"
"John Doe";"23";"0"
"Jane Doe";"42";"1"
```

The code:

```swift
struct Person: Decodable {
    let name: String
    let age: Int
    let doesLikeBurgers: Bool
}

let decoder = CSVDecoder()
decoder.configuration
    .decodeBoolean(trueValue: "1", falseValue: "0")

do {
    let listOfPeople = try decoder.decode([Person].self, fromFile: URL(fileURLWithPath: "listofpeople.csv"))
    print(listOfPeople)
} catch let error {
    print(error)
}
```

Output:

```plain
[Person(name: "John Doe", age: 23, doesLikeBurgers: false), Person(name: "Jane Doe", age: 42, doesLikeBurgers: true)]
```

### Example: Encoding

_Configuration not yet supported._

The code:

```swift
struct Person: Encodable {
    let name: String
    let age: Int
    let doesLikeBurgers: Bool
}

let listOfPeople = [
    Person(name: "John Doe", age: 23, doesLikeBurgers: false),
    Person(name: "Jane Doe", age: 42, doesLikeBurgers: true)
]

do {
    let csvData = try CSVEncoder().encode(listOfPeople)
    print(String(data: csvData, encoding: .utf8)!)
} catch let error {
    print(error)
}
```

Output:

```plain
"name","age","doesLikeBurgers"
"John Doe","23","false"
"Jane Doe","42","true"
```

### Limitations

As CSV-files are tables, some limitations with regards to data-structures exist. To have simple support for `Codable`, the optimal model is a flat struct of simple types, for example:

```swift
struct Demo: Codable {
    let aBool: Bool
    let aString: String
    let aDouble: Double
    let anInt: Int
}
```

Nested structures, like properties of non-primitive types or arrays of anything are **not supported**, for example:

```swift
struct Demo: Codable {
    let anArray: [String]
    let nestedType: Nested
    
    struct Nested: Codable {
        let aString: String
    }
}
```

**In decoding**, though, custom decoders can be configured, for example:

```swift
struct Demo: Decodable {
    let custom: Custom
    
    struct Custom: Decodable {
        let first: Int
        let second: Int
    }
}

decoder.configuration
    .addCustomDecoder {
        let values = $0.split(separator: "|")
        Custom(first: String(values[0]), second: String(values[1]))
    }
```

With a CSV-file like:

```plain
"custom"
"1|2"
"3|4"
"5|6"
```


## LogEncoder & LogDecoder

I created `LogEncoder` and `LogDecoder` to help me with understanding, how `Encoder` and `Decoder` works. I didn't find a lot of useful information. Most of it was "do this, do that", but no explanation of what is happening when and why.

`LogEncoder` will "encode" by writing output using `print()`, describing the current coding-path and function. `LogDecoder` decodes random-values and also prints the steps taken. Both helped me a lot to understand what is actually happening, especially weird cases.

So, if you have a use-case, a certain model that needs encoding into a format, you want to write an encoder for, you could do this:

```swift
struct Demo: Codable {
    let aBool: Bool
    let anOptional: Int?
    let aNested: Nested
    let anArray: [String]
    
    struct Nested: Codable {
        let anotherBool: Bool
        let anotherString: String
    }
}

let demo = Demo(
    aBool: true,
    anOptional: nil,
    aNested: Nested(
        anotherbool: false,
        anotherString: "Wahtuuup?"
    ),
    anArray: ["Hello", "World", "!"]
)

do {
    try LogEncoder().encode(demo)
} catch let error {
    print(error)
}
```

Output:

```plain
/ _LogEncoder.container(keyedBy:)
/ _LogKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(Bool)=true key=CodingKeys(stringValue: "aBool", intValue: nil)
/ _LogKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value<T>(Nested)=Nested(anotherBool: false, anotherString: "Wahtuuup?") key=CodingKeys(stringValue: "aNested", intValue: nil)
/ _LogEncoder.codingPath = /aNested
/aNested _LogEncoder.container(keyedBy:)
/aNested _LogKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(Bool)=false key=CodingKeys(stringValue: "anotherBool", intValue: nil)
/aNested _LogKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value(String)="Wahtuuup?" key=CodingKeys(stringValue: "anotherString", intValue: nil)
/aNested _LogEncoder.codingPath = /
/ _LogKeyedEncodingContainer<CodingKeys>.encode(_:forKey:) value<T>(Array<String>)=["Hello", "World", "!"] key=CodingKeys(stringValue: "anArray", intValue: nil)
/ _LogEncoder.codingPath = /anArray
/anArray _LogEncoder.unkeyedContainer()
/anArray _LogUnkeyedEncodingContainer.encode(_:) count=0 value<T>(String)=Hello
/anArray _LogEncoder.codingPath = /anArray/0
/anArray/0 _LogEncoder.singleValueContainer()
/anArray/0 _LogSingleValueEncodingContainer.encode(_:) value(String)="Hello"
/anArray/0 _LogUnkeyedEncodingContainer.count = 1
/anArray/0 _LogEncoder.codingPath = /anArray
/anArray _LogUnkeyedEncodingContainer.encode(_:) count=1 value<T>(String)=World
/anArray _LogEncoder.codingPath = /anArray/1
/anArray/1 _LogEncoder.singleValueContainer()
/anArray/1 _LogSingleValueEncodingContainer.encode(_:) value(String)="World"
/anArray/1 _LogUnkeyedEncodingContainer.count = 2
/anArray/1 _LogEncoder.codingPath = /anArray
/anArray _LogUnkeyedEncodingContainer.encode(_:) count=2 value<T>(String)=!
/anArray _LogEncoder.codingPath = /anArray/2
/anArray/2 _LogEncoder.singleValueContainer()
/anArray/2 _LogSingleValueEncodingContainer.encode(_:) value(String)="!"
/anArray/2 _LogUnkeyedEncodingContainer.count = 3
/anArray/2 _LogEncoder.codingPath = /anArray
/anArray _LogEncoder.codingPath = /
```
