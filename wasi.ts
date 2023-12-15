import Context from "https://deno.land/std@0.206.0/wasi/snapshot_preview1.ts";
// import { File, OpenFile, WASI } from "npm:@bjorn3/browser_wasi_shim";

const context = new Context({
  args: Deno.args,
  env: Deno.env.toObject(),
});

// const wasi = new WASI(
//   Deno.args,
//   Object.entries(Deno.env.toObject()).map(([key, value]) => key + "=" + value),
//   [
//     new OpenFile(new File([])),
//     new OpenFile(new File([])),
//     new OpenFile(new File([])),
//   ],
// );

const [log, flush] = (() => {
  let codes: number[] = [];
  function log(x: number) {
    if (x == "\n".charCodeAt(0)) {
      flush();
    } else if (x == "\r".charCodeAt(0)) { /* no op */ }
    else {
      codes.push(x);
    }
  }

  function flush() {
    if (codes.length > 0) {
      console.log(new TextDecoder().decode(new Uint8Array(codes).valueOf()));
      codes = [];
    }
  }
  return [log, flush];
})();

await WebAssembly.instantiateStreaming(
  fetch(
    // new URL("./wasi.wasm", import.meta.url),
    new URL("./target/wasm-gc/release/build/main/main.wasm", import.meta.url),
  ),
  {
    "spectest": { "print_char": log },
    "wasi_snapshot_preview1": context.exports,
  },
  // { "wasi_snapshot_preview1": wasi.wasiImport },
).then((obj) => {
  // wasi.start({
  //   exports: {
  //     memory: obj.instance.exports["moonbit.memory"] as WebAssembly.Memory,
  //     _start: obj.instance.exports["_start"] as () => unknown,
  //   },
  // // });
  try {
    context.start(obj.instance);
  } catch (e) {
    console.error(e);
  } finally {
    flush();
    // const memory = obj.instance.exports["memory"] as WebAssembly.Memory;
    // console.log(new Uint8Array(memory.buffer, 0, 100));
    // console.log(new Uint8Array(memory.buffer, 1020, 100));
  }
});
