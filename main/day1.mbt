fn day1() {
  // var line = " "
  // var sum = 0
  // while line.length() > 0 {
  // line = next(Pos(0))
  // if line.length() > 0 {
  // var i = 0
  // var first : Option[Int] = None
  // var last : Option[Int] = None
  // while i < line.length() {
  // let num = line.get(i).to_int() - 48
  // if num >= 0 && num <= 9 {
  // match first {
  // None => {
  // first = Some(num)
  // }
  // _ => ()
  // }
  // last = Some(num)
  // } else if num + 48 == 10 {
  // // new line
  // match (first, last) {
  // (Some(n), Some(m)) => {
  // sum = sum + 10 * n + m
  // }
  // }
  // first = None
  // last = None
  // }
  // i = i + 1
  // }
  // match (first, last) {
  // (Some(n), Some(m)) => {
  // sum = sum + 10 * n + m
  // }
  // }
  // }
  // }
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
