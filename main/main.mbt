

fn print_args(args : List[Bytes], pos : @lib.Pos) {
  fn aux(list : List[Bytes]) {
    match list {
      Cons(hd, tl) => {
        @lib.println(hd.to_string(), pos)
        aux(tl)
      }
      Nil => ()
    }
  }

  @lib.println("=== args ===", pos)
  aux(args)
  @lib.println("============", pos)
}

fn stream[A](array: Array[A]) -> List[A] {
  var list = List::Nil
  var i = array.length() - 1
  while i >= 0, i = i - 1 {
    list = Cons(array[i], list)
  }
  list
}

fn show[A: Show](list: List[A]) -> String {
  let a = Buffer::make(0)
  fn aux(l: List[A]) {
    match l {
      Nil => a.write_char(']')
      Cons(hd, tl) => {
        a.write_char(',')
        a.write_string(hd.to_string())
        aux(tl)
      }
    }
  }
  aux(list)
  a.bytes[0] = '['.to_int()
  a.to_string()
}

fn init {
  let start = @lib.get_clock_time(Realtime, 1000L, Pos(0))
  let parser1 = @lib.pchar('中')
  let parser2 = @lib.pchar('英')
  let parser3 = @lib.pchar('文')
  let Some(ch, rest) = parser1.or_else(parser2).and_then(parser3).parse("中文".to_bytes())
  @lib.println("Char: " + ch.0.to_string() + ch.1.to_string() + " Rest: " + rest.to_string(), Pos(0))
  let Some(digit, rest) = @lib.pint.parse("12345，上山打老虎".to_bytes())
  @lib.println("Digit: " + digit.to_string() + " Rest: " + rest.to_string(), Pos(0))
  let end = @lib.get_clock_time(Realtime, 1000L, Pos(0))
  match (start, end) {
    (Success(t1), Success(t2)) => {
      @lib.println("Start: " + t1.to_string(), Pos(0))
      @lib.println("End: " + t2.to_string(), Pos(0))
      @lib.println(
        "Time cost: " + ((t2 - t1) / 1000000L).to_string() + " ms",
        Pos(0),
      )
    }
    _ => ()
  }
}
