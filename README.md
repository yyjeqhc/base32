# Moonbit Base32 Library

This is a simple Base32 encoding and decoding library written in Moonbit.  
It provides functions to encode binary data into Base32 format and decode Base32-encoded data back to its original form.

## Features
- Encode bytes into Base32 format.
- Decode Base32-encoded data back into original bytes.
- Works with `Bytes` and `Array[Byte]` types.

## ISSUE
`map_init()` runs every time `base32_decode` is executed and will be optimized in the future.

## Usage

### Encoding Data
To encode data into Base32 format, use the `base32_encode` function:

```moonbit
let data = b"hello moonbit!"
let encoded = base32_encode(data)
println(encoded)
```

### Decoding Data

To decode Base32-encoded data back into its original form, use the `base32_decode` function:

```
let decoded = base32_decode(b"the bytes from base32_encode")
println(decoded) // should output: "hello moonbit!"
```

## API

### `base32_encode(data: Bytes) -> Array[Byte]`

Encodes the given `Bytes` into a Base32-encoded `Array[Byte]`.

### `base32_decode(data: Bytes) -> Array[Byte]`

Decodes a Base32-encoded `Bytes` back into its original `Array[Byte]`.

## License

This project is open-source and available under the MIT License.