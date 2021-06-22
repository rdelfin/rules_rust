# Code Generation for protobuf using the prost library
load("//rust:rust.bzl", "rust_binary", "rust_doc", "rust_library", "rust_test")

package(default_visibility = ["//visibility:private"])

rust_library(
    name = "prostgen_lib",
    srcs = [
        "extern_path.rs",
        "lib.rs",
        "module.rs",
    ],
    edition = "2018",
    deps = [
        %{anyhow},
        %{heck},
        %{prost},
        %{prost_build},
        %{prost_types},
        %{structopt},
        %{thiserror},
        %{tonic_build},
    ],
)

rust_binary(
    name = "prostgen",
    srcs = ["main.rs"],
    edition = "2018",
    visibility = ["//visibility:public"],
    deps = [
        ":prostgen_lib",
        %{anyhow},
        %{structopt},
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
