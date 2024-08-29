fn print_args(args : List[Bytes], pos : @lib.Pos) {
  fn aux(list : List[Bytes]) {
    match list {
      Cons(hd, tl) => {
        @lib.stdout.println(hd.to_string(), pos)
        aux(tl)
      }
      Nil => ()
    }
  }

  @lib.stdout.println("=== args ===", pos)
  aux(args)
  @lib.stdout.println("============", pos)
}

fn stream[A](array: Array[A]) -> List[A] {
  let mut list = List::Nil
  let mut i = array.length() - 1
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
  day2_part2()
  let end = @lib.get_clock_time(Realtime, 1000L, Pos(0))
  match (start, end) {
    (Success(t1), Success(t2)) => {
      @lib.stdout.println("Start: " + t1.to_string(), Pos(0))
      @lib.stdout.println("End: " + t2.to_string(), Pos(0))
      @lib.stdout.println(
        "Time cost: " + ((t2 - t1) / 1000000L).to_string() + " ms",
        Pos(0),
      )
    }
    _ => ()
  }
}
