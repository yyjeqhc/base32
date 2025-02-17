
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