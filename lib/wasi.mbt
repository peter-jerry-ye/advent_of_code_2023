type FileDescriptor Int

/// 内存区位置。使用时多数情况是从零开始。如果有嵌套请注意安全，例如write中使用get_clock_time
pub type Pos Int derive(Show)

/// 标记是否成功，或是失败
pub enum Result[T, E] {
  Success(T)
  Error(E)
}

fn fd_write_ffi(file : Int, pos : Int, len : Int, result : Int) -> Int = "wasi_snapshot_preview1" "fd_write"

/// file pos len result
fn fd_read_ffi(file : Int, pos : Int, len : Int, result : Int) -> Int = "wasi_snapshot_preview1" "fd_read"

fn args_sizes_get_ffi(arg_length : Int, arg_size : Int) -> Int = "wasi_snapshot_preview1" "args_sizes_get"

fn args_get_ffi(arg_pointers : Int, args : Int) -> Int = "wasi_snapshot_preview1" "args_get"

fn clock_time_get(clock_id: Int, precision: Int64, timeOffset: Int) -> Int = "wasi_snapshot_preview1" "clock_time_get"

pub enum ClockId {
  Realtime
  Monotonic
}

interface WriteToMemory  {
  write(Self, Pos)
  length(Self) -> Int // n element
  size(Self) -> Int // in byte
}

fn length(self : Int) -> Int {
  1
}

fn size(self : Int) -> Int {
  4
}

fn write(self : Int, pos : Pos) {
  store32(pos.0, self)
}

fn write(self : Memory, pos : Pos) {
  self.offset.write(pos)
  self.len.write(Pos(pos.0 + self.offset.size()))
}

fn length(self : Memory) -> Int {
  1
}

fn size(self : Memory) -> Int {
  8
}

fn write[T : WriteToMemory](self : List[T], pos : Pos) {
  fn aux(ls : List[T], pos : Pos) {
    match ls {
      Nil => ()
      Cons(hd, tl) => {
        hd.write(pos)
        aux(tl, Pos(pos.0 + hd.size()))
      }
    }
  }

  aux(self, pos)
}

fn length[T](self : List[T]) -> Int {
  match self {
    Nil => 0
    Cons(_, tl) => 1 + tl.length()
  }
}

fn size[T : WriteToMemory](self : List[T]) -> Int {
  match self {
    Nil => 0
    Cons(hd, tl) => hd.size() + tl.size()
  }
}

/// fd_write write to file
/// 写文件
pub fn fd_write(bytes : Bytes, file : FileDescriptor, pos : Pos) ->
     Result[Int, Int] {
  let memory = { offset: pos.0, len: bytes.length() }
  memory.from_bytes(bytes)
  let memories = List::Cons(memory, Nil)
  memories.write(Pos(pos.0 + bytes.length()))
  let errno = fd_write_ffi(
    file.0,
    pos.0 + bytes.length(),
    memories.length(),
    pos.0 + memories.size(),
  )
  if errno == 0 {
    Success(load32(pos.0 + memories.size()))
  } else {
    Error(errno)
  }
}

/// fd_read read from a file with given buffer length
/// 读取文件，限定缓冲区大小
pub fn fd_read(file : FileDescriptor, pos : Pos, len : Int) ->
     Result[Bytes, Int] {
  var result = 1
  var errno = 0
  store32(pos.0 + (0).size(), pos.0 + (0).size() * 3)
  store32(pos.0 + (0).size() * 2, len)
  errno = fd_read_ffi(file.0, pos.0 + (0).size(), 1, pos.0)
  result = load32(pos.0)
  if errno == 0 {
    Success(Memory::new(pos.0 + (0).size() * 3, result).to_bytes())
  } else {
    Error(errno)
  }
}

/// get_args 获取参数
pub fn get_args(pos : Pos) -> Result[List[Bytes], Int] {
  let errno = args_sizes_get_ffi(pos.0, (0).size())
  if errno != 0 {
    Error(errno)
  } else {
    let argv = load32(pos.0)
    let argc = load32(Pos::Pos(pos.0 + (0).size()).0)
    let errno = args_get_ffi(pos.0, argv * (0).size())
    if errno != 0 {
      Error(errno)
    } else {
      var i : Int = argv - 1
      var list : List[Bytes] = Nil
      while i >= 0 {
        let start = load32(pos.0 + i * (0).size())
        let end = if i != argv - 1 {
          load32(pos.0 + (i + 1) * (0).size())
        } else {
          argv * (0).size() + argc
        }
        let memory = Memory::new(start, end - start)
        let bytes = memory.to_bytes()
        list = Cons(bytes, list)
        i = i - 1
      }
      Success(list)
    }
  }
}

/// Real time -> nano second 纳秒
/// Monotonic -> pico second 皮秒
pub fn get_clock_time(clock_id: ClockId, resolution: Int64, pos: Pos) -> Result[Int64, Int] {
  let id = match clock_id {
    Realtime => 0
    Monotonic => 1
  }
  let errno = clock_time_get(id, resolution, pos.0)
  if errno != 0 {
    Error(errno)
  } else {
    Success(load64(pos.0))
  }
}

struct Memory {
  offset : Int
  len : Int
}

fn load8(pos : Int) -> Int = "(func $load8 (param $pos i32) (result i32) (i32.load8_u (local.get $pos)))"

fn load32(pos : Int) -> Int = "(func $load32 (param $pos i32) (result i32) (i32.load (local.get $pos)))"

fn load64(pos : Int) -> Int64 = "(func $load64 (param $pos i32) (result i64) (i64.load (local.get $pos)))"

fn store8(pos : Int, value : Int) = "(func $store8 (param $pos i32) (param $value i32) (i32.store8 (local.get $pos) (local.get $value)))"

fn store32(pos : Int, value : Int) = "(func $store32 (param $pos i32) (param $value i32) (i32.store (local.get $pos) (local.get $value)))"

fn store64(pos : Int, value : Int64) = "(func $store64 (param $pos i32) (param $value i64) (i64.store (local.get $pos) (local.get $value)))"

fn to_bytes(self : Memory) -> Bytes {
  let bytes = Bytes::make(self.len, 0)
  var i = 0
  while i < self.len {
    bytes[i] = load8(self.offset + i)
    i = i + 1
  }
  bytes
}

fn from_bytes(self : Memory, bytes : Bytes) -> Unit {
  fn min(i, j) {
    if i < j {
      i
    } else {
      j
    }
  }

  var i = 0
  while i < min(self.len, bytes.length()) {
    store8(self.offset + i, bytes[i])
    i = i + 1
  }
}

fn Memory::new(offset : Int, len : Int) -> Memory {
  { offset, len }
}

pub let stdin : FileDescriptor = FileDescriptor(0)

pub let stdout : FileDescriptor = FileDescriptor(1)

pub let stderr : FileDescriptor = FileDescriptor(2)
