fn main {
  // println(@lib.hello())
  let origin = b"hello"
  println(@lib.base32_encode(origin))

}
