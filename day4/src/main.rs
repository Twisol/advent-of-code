extern crate crypto;

use crypto::md5::Md5;
use crypto::digest::Digest;

fn find(key: &[u8], predicate: &Fn([u8; 16]) -> bool) -> Option<u64>{
  for i in 0..std::u64::MAX {
    let mut md5 = Md5::new();
    md5.input(key);
    md5.input(i.to_string().as_bytes());

    let mut output = [0u8; 16];
    md5.result(&mut output);

    if predicate(output) {
      return Some(i);
    }
  }

  return None;
}

fn five_zeroes(hash: [u8; 16]) -> bool {
  return (hash[0] as u16 + hash[1] as u16 + (hash[2] >> 4) as u16) == 0;
}

fn six_zeroes(hash: [u8; 16]) -> bool {
  return (hash[0] as u16 + hash[1] as u16 + hash[2] as u16) == 0;
}

fn main() {
  let key = include_bytes!("../input.txt");

  // println!("{:?}", &key[..key.len()-1]);
  println!("Part One: {:?}", find(&key[..key.len()-1], &five_zeroes));
  println!("Part Two: {:?}", find(&key[..key.len()-1], &six_zeroes));
}
