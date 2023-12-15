import { init, WASI } from "https://deno.land/x/wasm@v1.2.2/wasi.ts";

// This is needed to load the WASI library first (since is a Wasm module)
await init();

type Config = {
  readonly args?: string[];
  readonly env?: Record<string, string>;
  readonly stdin?: string;
};

const moduleBytes = fetch("./target/wasm-gc/release/build/main/main.wasm");
const module = await WebAssembly.compileStreaming(moduleBytes);
// Instantiate the WASI module

export async function run(config: Config) {
  const wasi = new WASI(config);
  await wasi.instantiate(module, {});

  // Run the start function
  wasi.setStdinString(config.stdin ?? "");
  const exitCode = wasi.start();
  const stdout = wasi.getStdoutString();

  console.log(`${stdout}(exit code: ${exitCode})`);
}
export const example_config: Config = {
  env: {},
  args: [
    "These",
    "are",
    "commands",
  ],
  stdin: "This should be\nechoed to the\nconsole",
};
