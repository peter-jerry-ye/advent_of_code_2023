# MoonBit Framework for Advent of Code

## Requirement 依赖

- Deno >= 1.38.0 (obligatory 必须)
- MoonBit >= 2023-12-11 (obligatory 必须)
- sed (any version should do? 现有版本应该都行)
- wasm-tools >= 1.0.53 (may lower will do 理论上低一些的也行，但未经测试)

## Usage 使用

Notice: `-A` will give all permission to the `deno`. 
If you don't trust me, do not use `-A` and check the permissions by yourself.

提示

- `deno run -A build.ts` : build the project
- `deno run -A wasi.ts` : execute the wasm application

## Organization 文件组织

- `lib/wasi.mbt` : Low level binding FFI 低级接口
- `lib/io.mbt` : High level binding 高级接口
- `main/main.mbt` : main function & example 主要入口与例子

## Happy Coding! 祝开发愉快

And merry christmas 以及新年快乐