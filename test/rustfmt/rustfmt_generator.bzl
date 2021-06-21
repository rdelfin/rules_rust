# buildifier: disable=module-docstring
# buildifier: disable=bzl-visibility
load("//rust/private:utils.bzl", "find_toolchain")

# buildifier: disable=print
print("WARNING: `rustfmt_generator` is deprecated. Instead, see https://bazelbuild.github.io/rules_rust/rustfmt.html")

def _rustfmt_generator_impl(ctx):
    toolchain = find_toolchain(ctx)
    rustfmt_bin = toolchain.rustfmt
    output = ctx.outputs.out

    args = ctx.actions.args()
    args.add("--stdout-file", output.path)
    args.add("--")
    args.add(rustfmt_bin.path)
    args.add("--emit", "stdout")
    args.add("--quiet")
    args.add(ctx.file.src.path)

    ctx.actions.run(
        executable = ctx.executable._process_wrapper,
        inputs = [ctx.file.src],
        outputs = [output],
        arguments = [args],
        tools = [rustfmt_bin],
        mnemonic = "Rustfmt",
    )

rustfmt_generator = rule(
    implementation = _rustfmt_generator_impl,
    doc = "Given an unformatted Rust source file, output the file after being run through rustfmt.",
    attrs = {
        "src": attr.label(
            doc = "The file to be formatted.",
            allow_single_file = True,
        ),
        "_process_wrapper": attr.label(
            default = Label("//util/process_wrapper"),
            executable = True,
            allow_single_file = True,
            cfg = "exec",
        ),
    },
    outputs = {"out": "%{name}.rs"},
    toolchains = [
        str(Label("//rust:toolchain")),
    ],
    incompatible_use_toolchain_transition = True,
)
