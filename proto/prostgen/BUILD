# Code Generation for protobuf using the prost library

load("//rust:rust.bzl", "rust_binary", "rust_doc", "rust_library", "rust_test")

package(default_visibility = ["//visibility:private"])

exports_files(["rules.bzl"])

rust_library(
    name = "prostgen_lib",
    srcs = [
        "extern_path.rs",
        "lib.rs",
        "module.rs",
    ],
    edition = "2018",
    deps = [
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:anyhow",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:heck",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:prost",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:prost_build",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:prost_types",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:structopt",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:thiserror",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:tonic_build",
    ],
)

rust_binary(
    name = "prostgen",
    srcs = ["main.rs"],
    visibility = ["//visibility:public"],
    edition = "2018",
    deps = [
        ":prostgen_lib",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:anyhow",
        "@io_bazel_rules_rust//proto/prostgen/raze/cargo:structopt",
    ],
)

rust_doc(
    name = "prostgen_doc",
    dep = ":prostgen_lib",
)

rust_test(
    name = "prostgen_test",
    crate = ":prostgen_lib",
)
