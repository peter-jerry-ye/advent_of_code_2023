fn day2() {
  var sum = 0
  let scanner = @lib.Scanner::make()
  var has_next = true 
  while has_next {
    let line = @lib.next_line(scanner, Pos(0))
    match line {
      Some(str) => {
        let validated = validate(str)
        sum = sum + validated
      }
      None => { has_next = false }
    }
  }
  @lib.stdout.println(sum.to_string(), Pos(0))
}

struct Game {
  blue: Int
  red: Int
  green: Int
} derive (Show)

fn validate(str: String) -> Int {
  let update_blue = @lib.pstring(" blue").map(fn (_str) { fn (count: Int) { fn (game: Game) { { ..game, blue: game.blue + count } } } } )
  let update_red = @lib.pstring(" red").map(fn (_str) { fn (count: Int) { fn (game: Game) { { ..game, red: game.red + count } } } } )
  let update_green = @lib.pstring(" green").map(fn (_str) { fn (count: Int) { fn (game: Game) { { ..game, green: game.green + count } } } } )
  let blue = @lib.pint.apply(update_blue)
  let red = @lib.pint.apply(update_red)
  let green = @lib.pint.apply(update_green)
  let update_set = (blue.or_else(red).or_else(green)).separated_by(@lib.pstring(", ")).map(fn (list) {
    fn aux(ls: List[(Game) -> Game]) {
      match ls {
        Nil => fn (g) {g}
        Cons(hd, tl) => fn (g) {aux(tl)(hd(g))}
      }
    }
    aux(list)
  })
  let check_set = @lib.pconst({blue: 0, red: 0, green: 0}).apply(update_set).map(fn (g) {
    g.red <= 12 && g.green <= 13 && g.blue <= 14
  })
  let check_game = check_set.separated_by(@lib.pstring("; ")).map(fn (list) {
    fn for_all(ls: List[Bool]) {
      match ls {
        Nil => true
        Cons(hd, tl) => hd && for_all(tl)
      }
    }
    for_all(list)
  })

  let game_number = @lib.omit_second(@lib.omit_first(@lib.pstring("Game ").and_then(@lib.pint)).and_then(@lib.pstring(": ")))
  
  match game_number.and_then(check_game).map(fn (pair) {
    if pair.1 { pair.0 } else { 0 }
  }).parse(str.to_bytes()) {
    Some(i, _) => i
    None => 0
  }
}

fn power(str: String) -> Int {
  let update_blue = @lib.pstring(" blue").map(fn (_str) { fn (count: Int) { fn (game: Game) { { ..game, blue: game.blue + count } } } } )
  let update_red = @lib.pstring(" red").map(fn (_str) { fn (count: Int) { fn (game: Game) { { ..game, red: game.red + count } } } } )
  let update_green = @lib.pstring(" green").map(fn (_str) { fn (count: Int) { fn (game: Game) { { ..game, green: game.green + count } } } } )
  let blue = @lib.pint.apply(update_blue)
  let red = @lib.pint.apply(update_red)
  let green = @lib.pint.apply(update_green)
  let update_set = (blue.or_else(red).or_else(green)).separated_by(@lib.pstring(", ")).map(fn (list) {
    fn aux(ls: List[(Game) -> Game]) {
      match ls {
        Nil => fn (g) {g}
        Cons(hd, tl) => fn (g) {aux(tl)(hd(g))}
      }
    }
    aux(list)
  })
  let get_set = @lib.pconst({blue: 0, red: 0, green: 0}).apply(update_set)
  let get_power = get_set.separated_by(@lib.pstring("; ")).map(fn (list) {
    fn max(i, j) {if i < j { j } else { i }}
    fn aux(ls: List[Game]) {
      match ls {
        Nil => {red: 0, green: 0, blue: 0}
        Cons(hd, tl) => {
          let rest = aux(tl)
          { red: max(hd.red, rest.red), blue: max(hd.blue, rest.blue), green: max(hd.green, rest.green) }
        }
      }
    }
    aux(list)
  })

  let game_number = @lib.omit_second(@lib.omit_first(@lib.pstring("Game ").and_then(@lib.pint)).and_then(@lib.pstring(": ")))
  
  match game_number.and_then(get_power).map(fn (pair) {
    let { red, green, blue } = pair.1
    red * green * blue
  }).parse(str.to_bytes()) {
    Some(i, _) => i
    None => 0
  }
}

fn day2_part2() {
  var sum = 0
  let scanner = @lib.Scanner::make()
  var has_next = true 
  while has_next {
    let line = @lib.next_line(scanner, Pos(0))
    match line {
      Some(str) => {
        let power = power(str)
        sum = sum + power
      }
      None => { has_next = false }
    }
  }
  @lib.stdout.println(sum.to_string(), Pos(0))
}