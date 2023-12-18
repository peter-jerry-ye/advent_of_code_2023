

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

fn init {
  let start = @lib.get_clock_time(Realtime, 1000L, Pos(0))
  // let args = @lib.get_args(Pos(0))
  // match args {
  //   Success(args) => print_args(args, Pos(0))
  // }
  // let scanner = @lib.Scanner::make()
  // var has_next = true
  // while has_next {
  //   let line = @lib.next_line(scanner, Pos(0))
  //   match line {
  //     Some(str) => {
  //       @lib.println(str, Pos(0))
  //     }
  //     None => { has_next = false }
  //   }
  // }
  day1_part2()
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
