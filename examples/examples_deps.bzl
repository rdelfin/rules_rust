"""Define dependencies for `rules_rust` examples"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@examples//complex_sys:repositories.bzl", "rules_rust_examples_complex_sys_repositories")
load("@examples//hello_sys/raze:crates.bzl", "rules_rust_examples_hello_sys_fetch_remote_crates")
load("@rules_foreign_cc//:workspace_definitions.bzl", "rules_foreign_cc_dependencies")
load("@rules_rust//bindgen:repositories.bzl", "rust_bindgen_repositories")
load("@rules_rust//proto:repositories.bzl", "rust_proto_repositories")
load("@rules_rust//proto/prostgen:repositories.bzl", "rust_prostgen_repositories")
load("@rules_rust//rust:repositories.bzl", "rust_repositories", "rust_repository_set")
load("@rules_rust//wasm_bindgen:repositories.bzl", "rust_wasm_bindgen_repositories")
load("@rules_rust//tools/rust_analyzer/raze:crates.bzl", "rules_rust_tools_rust_analyzer_fetch_remote_crates")
load("@examples//prostgen/raze:crates.bzl", "rules_rust_examples_prostgen_fetch_remote_crates")

def deps():
    """Define dependencies for `rules_rust` examples"""

    rust_repositories(include_rustc_srcs = True)

    rust_bindgen_repositories()

    rust_wasm_bindgen_repositories()

    rust_proto_repositories()

    rust_prostgen_repositories()

    rules_rust_tools_rust_analyzer_fetch_remote_crates()

    # Example of `rust_repository_set`
    rust_repository_set(
        name = "fake_toolchain_for_test_of_sha256",
        edition = "2018",
        exec_triple = "x86_64-unknown-linux-gnu",
        extra_target_triples = [],
        rustfmt_version = "1.4.12",
        sha256s = {
            "rust-1.46.0-x86_64-unknown-linux-gnu": "e3b98bc3440fe92817881933f9564389eccb396f5f431f33d48b979fa2fbdcf5",
            "rust-std-1.46.0-x86_64-unknown-linux-gnu": "ac04aef80423f612c0079829b504902de27a6997214eb58ab0765d02f7ec1dbc",
            "rustfmt-1.4.12-x86_64-unknown-linux-gnu": "1894e76913303d66bf40885a601462844eec15fca9e76a6d13c390d7000d64b0",
        },
        version = "1.46.0",
    )

    rules_rust_examples_hello_sys_fetch_remote_crates()

    rules_rust_examples_complex_sys_repositories()

    rules_rust_examples_prostgen_fetch_remote_crates()

    maybe(
        http_archive,
        name = "libc",
        build_file = "@examples//ffi:libc.BUILD",
        sha256 = "1ac4c2ac6ed5a8fb9020c166bc63316205f1dc78d4b964ad31f4f21eb73f0c6d",
        strip_prefix = "libc-0.2.20",
        urls = [
            "https://mirror.bazel.build/github.com/rust-lang/libc/archive/0.2.20.zip",
            "https://github.com/rust-lang/libc/archive/0.2.20.zip",
        ],
    )

    rules_foreign_cc_dependencies()
