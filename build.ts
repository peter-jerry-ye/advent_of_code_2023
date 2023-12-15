// build wat
const build_wat = new Deno.Command("moon", {
  args: ["build", "--target", "wasm-gc", "--output-wat"],
  env: Deno.env.toObject(),
});
const edit_wat = new Deno.Command("sed", {
  args: [
    "-i",
    "-e",
    "s/export \"moonbit\\.memory\"/export \"memory\"/g",
    "target/wasm-gc/release/build/main/main.wat",
  ],
  env: Deno.env.toObject(),
});
const build_wasm = new Deno.Command("wasm-tools", {
  args: [
    "parse",
    "target/wasm-gc/release/build/main/main.wat",
    "-o",
    "target/wasm-gc/release/build/main/main.wasm",
  ],
  env: Deno.env.toObject(),
});

await build_wat.spawn().status;
await edit_wat.spawn().status;
await build_wasm.spawn().status;
