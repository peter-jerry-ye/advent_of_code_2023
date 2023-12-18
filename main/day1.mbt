fn day1() {
  var sum = 0
  let scanner = @lib.Scanner::make()
  var has_next = true 
  while has_next {
    let line = @lib.next_line(scanner, Pos(0))
    match line {
      Some(str) => {
        var i = 0
        var first : Option[Int] = None
        var last : Option[Int] = None
        while i < str.length() {
          let num = str.get(i).to_int() - 48
          if num >= 0 && num <= 9 {
            match first {
              None => {
                first = Some(num)
              }
              _ => ()
            }
            last = Some(num)
          }
          i = i + 1
        }
        match (first, last) {
          (Some(n), Some(m)) => {
            sum = sum + 10 * n + m
          }
          _ => @lib.println("None?", Pos(0))
        }
      }
      None => { has_next = false }
    }
  }
  @lib.println(sum.to_string(), Pos(0))
}

fn starts_with(str1: String, offset: Int, str2: String) -> Bool {
  if str1.length() < offset + str2.length() {
    false
  } else {
    var i = 0
    while i < str2.length(), i = i + 1 {
      if str1[offset + i] != str2[i] {
        return false
      }
    }
    true
  }
}

fn match_str(str: String, offset: Int) -> Option[Int] {
  let predicate = fn (pattern) { starts_with(str, offset, pattern) }
  if predicate("1") || predicate("one") {
    Some(1)
  } else if predicate("2") || predicate("two") {
    Some(2)
  } else if predicate("3") || predicate("three") {
    Some(3)
  } else if predicate("4") || predicate("four") {
    Some(4)
  } else if predicate("5") || predicate("five") {
    Some(5)
  } else if predicate("6") || predicate("six") {
    Some(6)
  } else if predicate("7") || predicate("seven") {
    Some(7)
  } else if predicate("8") || predicate("eight") {
    Some(8)
  } else if predicate("9") || predicate("nine") {
    Some(9)
  } else { None }
}

fn day1_part2() {
  var sum = 0
  let scanner = @lib.Scanner::make()
  var has_next = true 
  while has_next {
    let line = @lib.next_line(scanner, Pos(0))
    match line {
      Some(str) => {
        var i = 0
        var first : Option[Int] = None
        var last : Option[Int] = None
        while i < str.length(), i = i + 1 {
          match match_str(str, i) {
            Some(v) => {
              match first {
                None => { first = Some(v) }
                _ => { () }
              }
              last = Some(v)
            }
            None => { () }
          }
        }
        match (first, last) {
          (Some(n), Some(m)) => {
            sum = sum + 10 * n + m
          }
          _ => @lib.println("None?", Pos(0))
        }
      }
      None => { has_next = false }
    }
  }
  @lib.println(sum.to_string(), Pos(0))
}