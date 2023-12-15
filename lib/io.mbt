pub fn print(str : String, pos : Pos) {
  fd_write(str.to_bytes(), stdout, pos)
  ()
}

pub fn println(str : String, pos : Pos) {
  print(str + "\n", pos)
}

pub struct Scanner {
  priv mut str : String
}

pub fn Scanner::make() -> Scanner {
  { str : "" }
}

pub fn next_line(scanner : Scanner, pos : Pos) -> Option[String] {
  var i = 0
  if scanner.str.length() == 0 {
    scanner.str = next(pos)
  }
  while i < scanner.str.length() {
    if scanner.str[i] == '\n' {
      let bytes = scanner.str.to_bytes()
      let result = bytes.sub_string(0, i)
      scanner.str = bytes.sub_string(i + 1, scanner.str.length() - i - 1)
      return Some(result)
    }
    i = i + 1
    if i == scanner.str.length() {
      scanner.str = scanner.str + next(pos)
    }
  }
  if scanner.str.length() > 0 {
    let result = scanner.str
    scanner.str = ""
    Some(result)
  } else {
    None
  }
}

/// return whatever comes next. Not necessarily one line
pub fn next(pos : Pos) -> String {
  var bytes = Bytes::make(0, 0)
  let buffer = 4096
  var result = buffer
  while result == buffer {
    let res = fd_read(stdin, pos, buffer)
    match res {
      Success(read) => {
        result = read.length()
        let b = Bytes::make(bytes.length() + result, 0)
        b.blit(0, bytes, 0, bytes.length())
        b.blit(bytes.length(), read, 0, result)
        bytes = b
      }
    }
  }
  bytes.to_string()
}
