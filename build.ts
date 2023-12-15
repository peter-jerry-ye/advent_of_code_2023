import { bundle } from "https://deno.land/x/emit@0.32.0/mod.ts";
const build_index = async () => {
  console.log("Bundling index.ts")
  const index = await bundle(
    new URL("./index.ts", import.meta.url),
  );
  await Deno.writeFile("index.mjs", new TextEncoder().encode(index.code));
  console.log("Generated index.mjs")
};

// build wat
const build_wat = new Deno.Command("moon", {
  args: ["build", "--target", "wasm-gc", "--output-wat"],
  env: Deno.env.toObject(),
});
// make wat wasi-preview-1-compatible
const edit_wat = async () => {
  console.log("Editing wat")
  const wat_file = await Deno.readFile(
    "target/wasm-gc/release/build/main/main.wat",
  );
  const wat = new TextDecoder().decode(wat_file);
  const memory_renamed = wat.replace(
    /export \"moonbit\.memory\"/,
    'export "memory"',
  );
  const remove_import = memory_renamed.replace(
    '(func $printc (import "spectest" "print_char") (param $i i32))',
    "(func $printc (param $i i32) (nop))",
  );
  await Deno.writeFile(
    "target/wasm-gc/release/build/main/main.wat",
    new TextEncoder().encode(remove_import),
  );
  console.log("Modified wat")
};
// compile wat to wasm
const build_wasm = new Deno.Command("wasm-tools", {
  args: [
    "parse",
    "target/wasm-gc/release/build/main/main.wat",
    "-o",
    "target/wasm-gc/release/build/main/main.wasm",
  ],
  env: Deno.env.toObject(),
});

await build_index()
await build_wat.spawn().status;
await edit_wat();
await build_wasm.spawn().status;
