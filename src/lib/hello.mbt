///Base32 编码 是一种将二进制数据转换为文本格式的编码方式，主要用于解决以下领域的实际问题：
///
///1. 数据传输与存储
///问题：
///二进制数据在传输或存储时可能会遇到问题，例如：
///
///某些系统或协议（如电子邮件、URL）不支持直接传输二进制数据。
///
///二进制数据可能包含不可打印字符或控制字符，导致传输错误。
///
///解决方案：
///Base32 将二进制数据编码为可打印的 ASCII 字符（A-Z 和 2-7），确保数据可以在文本系统中安全传输和存储。
///
///2. 人类可读性与易用性
///问题：
///二进制数据对人类不友好，难以阅读、记忆或手动输入。
///
///在某些场景（如手写、语音传输）中，需要避免容易混淆的字符（如 0 和 O，1 和 I）。
///
///解决方案：
///Base32 使用大写字母和数字，排除了容易混淆的字符（如 0、1、8、9），使编码结果更易于人类阅读和手动处理。
///
///3. 文件命名与标识
///问题：
///在某些文件系统中，文件名可能对字符集有限制（如不支持特殊字符或区分大小写）。
///
///需要生成唯一的、可读的文件名或标识符。
///
///解决方案：
///Base32 编码生成的文件名仅包含大写字母和数字，兼容大多数文件系统。
///
///可以用于生成短链接、唯一 ID 或文件名。
///
///4. 密码学与安全
///问题：
///在某些安全场景中，需要将二进制密钥或哈希值转换为可打印的文本格式。
///
///需要避免字符集导致的混淆或错误。
///
///解决方案：
///Base32 常用于编码 TOTP（基于时间的一次性密码）密钥，如 Google Authenticator 使用的密钥。
///
///也用于编码加密密钥或哈希值，方便存储和传输。
///
///5. URL 与文件名安全
///问题：
///URL 和文件名中不能包含某些特殊字符（如 /、+、=），否则可能导致解析错误。
///
///Base64 编码包含这些字符，不适合直接用于 URL 或文件名。
///
///解决方案：
///Base32 编码不包含特殊字符（仅使用 A-Z 和 2-7），适合用于 URL 和文件名。
///
///6. 嵌入式系统与低带宽环境
///问题：
///在嵌入式系统或低带宽环境中，数据传输需要高效且兼容性强。
///
///二进制数据可能无法直接传输或存储。
///
///解决方案：
///Base32 编码将二进制数据转换为文本格式，适合在低带宽环境中传输。
///
///由于字符集简单，解码逻辑也相对简单，适合嵌入式系统。
///
///实际应用场景
///TOTP（基于时间的一次性密码）：
///
///Google Authenticator、Microsoft Authenticator 等工具使用 Base32 编码存储密钥。
///
///短链接与唯一标识符：
///
///生成短链接或唯一 ID，如 YouTube 视频 ID。
///
///文件命名：
///
///生成唯一的、可读的文件名，避免特殊字符问题。
///
///电子邮件附件：
///
///将二进制附件编码为文本格式，确保通过电子邮件传输时不丢失数据。
///
///URL 安全传输：
///
///将二进制数据编码为 Base32，用于 URL 参数或路径中。
///
///硬件设备配置：
///
///在嵌入式设备中，使用 Base32 编码存储配置信息或密钥。
///### Encoding Data
///To encode data into Base32 format, use the `base32_encode` function:
///```moonbit
///let data = b"hello moonbit!"
///let encoded = base32_encode(data)
///println(encoded)
///```
///
///### Decoding Data
///
///To decode Base32-encoded data back into its original form, use the `base32_decode` function:
///
///```
///let decoded = base32_decode(b"the bytes from base32_encode")
///println(decoded) // should output: "hello moonbit!"
///```

pub fn base32_encode(data:Bytes) ->Array[Byte] {
//   const B64: [Char; 33] = [
//     'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
//     '2', '3', '4', '5', '6', '7', '='
// ];
  let b64 = b"ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
  let lens = data.length()
  //剩下的字节单独处理
  let bytes_left = lens%5
  //处理能被整除的数据
  let lens = lens - bytes_left

  let mut capacity = (lens/5)*8
  if bytes_left>0 {
    capacity = capacity + 8
  }
  let result= Array::new(capacity=capacity)
  
  let index = lens/5

  //5个字节，40位，分给8个字节，每个字节000+5位分配的
  //先处理前面3的整数倍字节
  for i =0;i<index;i=i+1 {
    let a1 = data[i*5+0]>>3
    let a2 = data[i*5+0]<<5>>3 | data[i*5+1]>>6
    let a3 = data[i*5+1]<<2>>3
    let a4 = data[i*5+1]<<7>>3 | data[i*5+2]>>4
    let a5 = data[i*5+2]<<4>>3 | data[i*5+3]>>7
    let a6 = data[i*5+3]<<1>>3
    let a7 = data[i*5+3]<<6>>3 | data[i*5+4]>>5
    let a8 = data[i*5+4]<<3>>3
    result.push(a1)
    result.push(a2)
    result.push(a3)
    result.push(a4)
    result.push(a5)
    result.push(a6)
    result.push(a7)
    result.push(a8)
  }
  //剩余的字节单独处理，并进行填充
  match bytes_left {
    1=>{
        let a1 = data[index*5+0]>>3
        let a2 = data[index*5+0]<<5>>3
        result.push(a1)
        result.push(a2)
        result.push(32)
        result.push(32)
        result.push(32)
        result.push(32)
        result.push(32)
        result.push(32)
    }
    2=>{
        let a1 = data[index*5+0]>>3
        let a2 = data[index*5+0]<<5>>3 | data[index*5+1]>>6
        let a3 = data[index*5+1]<<2>>3
        let a4 = data[index*5+1]<<7>>3
        result.push(a1)
        result.push(a2)
        result.push(a3)
        result.push(a4)
        result.push(32)
        result.push(32)
        result.push(32)
        result.push(32)

    }
    3=> {
        let a1 = data[index*5+0]>>3
        let a2 = data[index*5+0]<<5>>3 | data[index*5+1]>>6
        let a3 = data[index*5+1]<<2>>3
        let a4 = data[index*5+1]<<7>>3 | data[index*5+2]>>4
        let a5 = data[index*5+2]<<4>>3
        result.push(a1)
        result.push(a2)
        result.push(a3)
        result.push(a4)
        result.push(a5)
        result.push(32)
        result.push(32)
        result.push(32)
    }
    4=>{
        let a1 = data[index*5+0]>>3
        let a2 = data[index*5+0]<<5>>3 | data[index*5+1]>>6
        let a3 = data[index*5+1]<<2>>3
        let a4 = data[index*5+1]<<7>>3 | data[index*5+2]>>4
        let a5 = data[index*5+2]<<4>>3 | data[index*5+3]>>7
        let a6 = data[index*5+3]<<1>>3
        let a7 = data[index*5+3]<<6>>3
        result.push(a1)
        result.push(a2)
        result.push(a3)
        result.push(a4)
        result.push(a5)
        result.push(a6)
        result.push(a7)
        result.push(32)
    }
    _ => {ignore("")}
  }
  for i=0;i<result.length();i=i+1 {
      result[i] = b64[result[i].to_int()]
  }
  result
}

let m:Map[Byte,Byte] = Map::new()
pub fn base32_decode(data:Bytes) ->Array[Byte] {
  map_init()
  let lens = data.length();
  let data = data.to_array();
  for i=0;i<lens;i=i+1 {
      data[i] = m[data[i]].unwrap();
  }
  let mut sub_count = 0;
  let mut i = lens-1; // 从末尾开始检查，确保不越界
  // 逐个检查字节
  while data[i] == 32 {
      data[i] = 0; // 设置为0
      sub_count += 1; // 计数加1
      i -= 1; // 向前移动
  }
  //向量的分配可以一开始就确定容量
  let capacity = lens*5/8;
  let result = Array::new(capacity=capacity);
  let lens = lens/8;

  //按位操作，还原字节
  for index=0;index<lens;index=index+1 {
      let a1 = data[index * 8 + 0] << 3 | data[index * 8 + 1] >> 2;
      let a2 = data[index * 8 + 1] << 6 | data[index * 8 + 2] << 1 | data[index * 8 + 3] >> 4;
      let a3 = data[index * 8 + 3] << 4 | data[index * 8 + 4] >> 1;
      let a4 = data[index * 8 + 4] << 7 | data[index * 8 + 5] << 2 | data[index * 8 + 6] >> 3;
      let a5 = data[index * 8 + 6] << 5 | data[index * 8 + 7];
      result.push(a1);
      result.push(a2);
      result.push(a3);
      result.push(a4);
      result.push(a5);
  }
  //去掉填充的字符
  match sub_count {
      1 => {
          let _ = result.pop();
      }
      3 => {
          let _ = result.pop();
          let _ = result.pop();
      }
      4 => {
          let _ = result.pop();
          let _ = result.pop();
          let _ = result.pop();
      }
      6=> {
          let _ = result.pop();
          let _ = result.pop();
          let _ = result.pop();
          let _ = result.pop();
      }
      _ => {ignore("")}
  }
  result
}
pub fn map_init()->Unit {
  let b64 = b"ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
  for i,b in b64 {
    m[b] = i.to_byte()
  }
}