# TextbookRSA
A textbook implementation of RSA encryption, for teaching purposes.

> DON'T YOU DARE USE THIS FRAMEWORK FOR REAL-WORLD ENCRYPTION!

[![Platforms](https://img.shields.io/cocoapods/p/TextbookRSA.svg)](https://cocoapods.org/pods/TextbookRSA)
[![License](https://img.shields.io/cocoapods/l/TextbookRSA.svg)](https://github.com/imagineon/TextbookRSA/blob/master/LICENSE)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/TextbookRSA.svg)](https://cocoapods.org/pods/TextbookRSA)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

- [Introduction](#introduction)
- [Use of ECB](#ecb)
- [Sending a secret message](#normal-use)
	- [Generating keys](#keys)
	- [Generating and sending encryption parameters](#encryption-parameters)
	- [Encrypting and sending data/text](#encrypting)
	- [Decrypting with private keys](#decrypting-with-keys)
- [Eavesdropping and decrypting with a period finder](#decrypting-with-period)
- [Installing](#installing)
	- [CocoaPods](#cocoapods)
	- [Swift Package Manager](#spm)
- [License](#license)

<a name="introduction"></a>

TextbookRSA is a framework written in `swift` with the goal of providing a (very) simplified and readable implementation of RSA encryption for beginners. On top of that, it contains an implementation of "decryption through period finding", which shows how RSA encryption could be broken if one had a fast period-finding oracle (e.g. a quantum computer with an implementation of Shor's algorithm).

One of the most important aspects of RSA encryption is the *length* of the public key. Modern standards require 2048 bits or more, while encryption with 1024 bits is still in use but slightly discouraged, and using 512 bits is already considered quite dangerous. In this framework, the key length is never more than 32 bits, so I reiterate: DON'T YOU DARE USE THIS FRAMEWORK FOR REAL-WORLD ENCRYPTION! The reason why our keys are so short, is because we didn't want to implement a "big integer" type (we just use the existing types `UInt` and `UInt32`). Large-integer arithmetics can be very interesting, but it is not conceptually part of RSA encryption, and our goal here was to focus on the fundamentals.

## <a name="ecb"></a> ECB

RSA encryption is what is called *asymmetric* or *public key* encryption. It encrypts *blocks* (which are simply integers) individually and these must be smaller than the public key. In particular, the limited size of the blocks means that we can only send very short messages via RSA.

Unfortunately, this framework would be rather boring if we could only encrypt some individual, tiny numbers. To allow the users to encrypt arbitrary messages, we added a higher level protocol called *Electronic Codebook* (ECB). This is a form of *block cypher scheme* in which the original message is simply chopped up into smaller pieces (blocks) and each of these is encrypted in isolation.

Again, this was added only to make the use of the framework more interesting and palpable, but it is strongly discouraged for real-world applications. Using RSA in block cypher schemes is generally a bad idea, as well as very inefficient, and even with other encryption protocols ECB is a bad and outdated choice. It is, however, the simplest to understand and to implement.

## <a name="normal-use"></a> Alice wants to send Bob a secret message

Let us go through a typical exchange using RSA and exemplify each step using our framework.

### Step 0: Choose the implementation we want to use

Currently the only implementation of `RSAProtocol` is `UIntRSA`, so we may start with some code sugar

```swift
typealias RSA = UIntRSA
```

### <a name="keys"></a> Step 1: Bob generates and saves his keys

```swift
let keys = RSA.Keys()
```

The `keys` object holds the private keys, that is, the two prime factors of the public key. It is `CustomStringConvertible` so you can print it nicely, and it is `Codable`, so Bob can easily generate a JSON file to store his keys somewhere on his computer:

```swift
let keysJSON = try JSONEncoder().encode(keys)

// ... store `keysJSON` (type `Data`) somewhere (safe) on the computer.
```

### <a name="encryption-parameters"></a> Step 2: Bob generates encryption parameters and sends them to Alice

```swift
let encryptionParms = keys.generateEncryptionParameters()
```

These parameters contain the public key (as the member `modulo`) and an encryption exponent. Again, they are `CustomStringConvertible` and `Codable`, so Bob can generate a JSON file to send to Alice (these parameters are public, so any communication channel can be used safely):

```swift
let encryptionParmsJSON = try JSONEncoder().encode(encryptionParms)

// ... send `encryptionParmsJSON` to Alice via e-mail/SMS/smoke signals...
```

### <a name="encrypting"></a> Step 3: Alice encrypts her message and sends it to Bob

Alice receives Bob's (public) message containing the encryption parameters as a JSON file and turns it into an `RSA.TransformationParameters` object again:

```swift
let encryptionParmsJSON = Data(/* ... get the JSON data sent by Bob ... */)
let encryptionParms = try JSONDecoder().decode(
    RSA.TransformationParameters.self, from: encryptionParmsJSON)
```

Now Alice can use the encryption parameters to encrypt her secret message. If her message is an arbitrary file, i.e. a stream of bytes, she can encrypt an object of type `Data`:

```swift
let message = Data(/* ... get data from a file ... */)
let encryptedMessage = Encrypter.encrypt(message, parameters: encryptionParms)
```

If, on the other hand, Alice just wants to encrypt a text string, she can use the convenience overload that takes a `String` parameter instead:

```swift
let message = "Hi, Bob. The code for my safe is 1234."
let encryptedMessage = Encrypter.encrypt(message, parameters: encryptionParms)
```

The object `encryptedMessage` is of type `Encrypter.EncryptedData`. It contains not only the result of the encryption, but also part of the encryption parameters again (namely, the exponent). This is important because Bob will probably use the same keys for many conversations, with many different people, but for each message he should generate new encryption parameters, and he will need to know which parameters go with which message, in order to decrypt them in the end.

Again, this type is `CustomStringConvertible` and `Codable`, so Alice can easily send her encrypted message (which is public) to Bob:

```swift
let encryptedMessageJSON = try JSONEncoder().encode(encryptedMessage)

// ... send `encryptedMessageJSON` to Bob via e-mail/SMS/smoke signals...
```

### <a name="decrypting-with-keys"></a> Step 4: Bob decrypts Alice's message

First, Bob needs to turn the JSON data he received into an `Encrypter.EncryptedData` object again:

```swift
let encryptedMessageJSON = Data(/* ... get the JSON data sent by Alice ... */)
let encryptedMessage = try JSONDecoder().decode(
    Encrypter.EncryptedData.self, from: encryptedMessageJSON)
```

He will also need his keys, which are stored somewhere in a file:

```swift
let keysJSON = Data(/* ... get the JSON data for the keys from a file */)
let keys = try JSONDecoder().decode(RSA.Keys.self, from: keysJSON)
```

Using the keys, Bob can initialize a `Decrypter`:

```swift
let decrypter = Decrypter(keys: keys)
```

Finally, Bob can decrypt Alice's message. The base method decrypts the message into a `Data` object:

```swift
let message = decrypter.decrypt(encryptedMessage) // `message` is of type `Data`
```

If they (publicly) agreed that Alice would send a text message, Bob can use the convenience method `decryptText` which returns a `String` instead:

```swift
let message = decrypter.decryptText(encryptedMessage) // `message` is of type `String`
```

## <a name="decrypting-with-period"></a> Eve tries to decrypt Alice's message

As in most textbook introductions to RSA, we pretend an eavesdropper called Eve has been listening to the conversation and wants to decrypt Alice's message using only public information (i.e. without knowing the prime factors of the public key). One way this can theoretically be done is if Eve has a fast period oracle for modular exponentiation.

To be precise, given positive numbers `m` (the additive group order) and `b` (the base of the exponentiation), consider the function `f(x) = b^x (mod m)`. If `b` and `m` are coprime (have no common non-trivial factors), then this function has a period. That is, there exists a positive number `r` such that `f(x) = f(x + r)` for every `x`. This period is *very* hard to find, and if someone finds a way to compute it quickly, RSA is in serious trouble (as will be shown below).

In our framework, we have implemented the class `PeriodOracle` (actually an `enum` with a static method), which computes such periods of modular exponentiation with a "brute force" approach (i.e. it just computes `f(1)`, `f(2)`, `f(3)`... until the values start to repeat). This is extremely slow, and can only be done in practice when dealing with small numbers. There are much more advanced algorithms for computing periods, but even the fastest ones are useless against public keys with thousands of bits.

The class `PeriodDecrypter` is a second implementation of the `DecrypterProtocol` (the first one being the class `Decrypter`) and it uses the `PeriodOracle` to decrypt messages without knowing the private keys. The theory of how this is done and why it works is out of the scope of this "README". We just want to show how the framework is used. Here is how Eve would proceed to use `PeriodDecrypter`:

```swift
// Listen to public information being sent between Alice and Bob:
let encryptionParmsJSON = Data(/* ... get the JSON data for the encryption parameters ... */)
let encryptedMessageJSON = Data(/* ... get the JSON data for the encrypted message ... */)

// Convert JSON data into objects from the framework:
let encryptionParms = try JSONDecoder().decode(
    RSA.TransformationParameters.self, from: encryptionParmsJSON)
let encryptedMessage = try JSONDecoder().decode(
    Encrypter.EncryptedData.self, from: encryptedMessageJSON)

// Initialize a decrypter:
let decrypter = PeriodDecrypter(publicKey: encryptionParms.modulo)
```

After this, decryption works exactly as with the `Decrypter` type, that is, the base method decrypts to `Data`:

```swift
let message = decrypter.decrypt(encryptedMessage) // `message` is of type `Data`
```

and the convenience method `decryptText` goes one step further and converts the data into `String`:

```swift
let message = decrypter.decryptText(encryptedMessage) // `message` is of type `String`
```

__IMPORTANT:__ Remember how we said that period finding is *really* hard? If you try to use a `PeriodDecrypter` with a large public key, the computation might take a day, or a year, or thousands of years. Even with our tiny public keys of up to 32 bits it would take way too long. In order for you to be able to test period-based decryption we added a static method `small(maxPrime: UInt32)` to the class `UIntRSAKeys`. With this method you can specify an upper bound for the prime factors of the public key. An upper bound of 100 seems to result in fairly quick tests. How high you want to go, it up to you. So when you want  to run tests using period-based decryption, make sure you replace the line where Bob initializes his keys with something like:

```swift
let keys = RSA.Keys.small(maxPrime: 100)
```

## <a name="installing"></a> Installing

Besides the obvious possibility of cloning the repository manually and using/modifying the source files as you wish, we also support installation via CocoaPods and the Swift Package Manager.

### <a name="cocoapods"></a> CocoaPods

To install TextbookRSA as a pod, add the line

```ruby
pod 'TextbookRSA', '~> 0.0.1'
```

to your `Podfile` and run

```bash
$ pod install
```

If you're not familiar with CocoaPods, you can learn all about it [here](http://cocoapods.org).

### <a name="spm"></a> Swift Package Manager

To install TextbookRSA via SPM, open `Package.swift`, add the dependency

```swift
.package(url: "https://github.com/imagineon/TextbookRSA.git", from: "0.0.2")
```

to your `package` constant and the dependency 

```swift
"TextbookRSA"
```

to each target that should use this framework. Then run

```bash
$ swift build
```

If you're not familiar with SPM, you can learn all about it [here](https://swift.org/package-manager/).

## <a name="license"></a> License

TextbookRSA is distributed with an MIT license (click [here](https://github.com/imagineon/TextbookRSA/blob/master/LICENSE) for more details). But have I mentioned it is not meant for real-world applications? DON'T YOU DARE USE THIS FRAMEWORK FOR REAL-WORLD ENCRYPTION!
