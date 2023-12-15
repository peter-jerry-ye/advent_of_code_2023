// build wat
const build_wat = new Deno.Command("moon", {
  args: ["build", "--target", "wasm-gc", "--output-wat"],
  env: Deno.env.toObject(),
});
const edit_wat = async () => {
  const wat_file = await Deno.readFile(
    "target/wasm-gc/release/build/main/main.wat",
  );
  const wat = new TextDecoder().decode(wat_file);
  const memory_renamed = wat.replace(/export \"moonbit\.memory\"/, 'export "memory"');
  const remove_import = memory_renamed.replace("(func $printc (import \"spectest\" \"print_char\") (param $i i32))", "(func $printc (param $i i32) (nop))");
  await Deno.writeFile(
    "target/wasm-gc/release/build/main/main.wat",
    new TextEncoder().encode(remove_import),
  );
};
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
await edit_wat();
await build_wasm.spawn().status;
