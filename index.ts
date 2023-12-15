import { init, WASI } from 'https://deno.land/x/wasm@v1.2.2/wasi.ts';

// This is needed to load the WASI library first (since is a Wasm module)
await init();

const wasi = new WASI({
  env: {
  },
  args: [
    "These", "are", "commands"
  ],
});

const moduleBytes = fetch("./target/wasm-gc/release/build/main/main.wasm");
const module = await WebAssembly.compileStreaming(moduleBytes);
// Instantiate the WASI module
await wasi.instantiate(module, {});

// Run the start function
wasi.setStdinString("Hello World!\nThis should give an echo.")
const exitCode = wasi.start();
const stdout = wasi.getStdoutString();

 // This should print "hello world (exit code: 0)"
console.log(`${stdout}(exit code: ${exitCode})`);