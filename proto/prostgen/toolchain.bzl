# Copyright 2021 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Toolchain for compiling protobuf and gRPC rust stubs with and for use by prost and tonic."""

ProstGenToolInfo = provider(
    doc = "Information about dependencies used by the tonic+prost generators.",
    # In the real world, compiler_path and system_lib might hold File objects,
    # but for simplicity they are strings for this example. arch_flags is a list
    # of strings.
    fields = [
        "anyhow",
        "heck",
        "prost",
        "prost_build",
        "prost_types",
        "structopt",
        "thiserror",
        "tonic_build",
        "protoc",
    ],
)

def _rust_prostgen_toolchain_impl(ctx):
    return platform_common.ToolchainInfo(
        prostgen_tool_info=ProstGenToolInfo(
            anyhow = ctx.attr.anyhow,
            heck = ctx.attr.heck,
            prost = ctx.attr.prost,
            prost_build = ctx.attr.prost_build,
            prost_types = ctx.attr.prost_types,
            structopt = ctx.attr.structopt,
            thiserror = ctx.attr.thiserror,
            tonic_build = ctx.attr.tonic_build,
            protoc = ctx.executable.protoc,
        )
    )

rust_prostgen_toolchain = rule(
    implementation = _rust_prostgen_toolchain_impl,
    attrs = {
        "anyhow": attr.label(
            doc = "The location of the anyhow Rust library.",
            default = "@rules_rust//proto/prostgen/raze/cargo:anyhow",
        ),
        "heck": attr.label(
            doc = "The location of the heck Rust library.",
            default = "@rules_rust//proto/prostgen/raze/cargo:heck",
        ),
        "prost": attr.label(
            doc = "The location of the prost Rust library.",
            default = "@rules_rust//proto/prostgen/raze/cargo:prost",
        ),
        "prost_build": attr.label(
            doc = "The location of the prost_build Rust library.",
            default = "@rules_rust//proto/prostgen/raze/cargo:prost_build",
        ),
        "prost_types": attr.label(
            doc = "The location of the prost_types Rust library.",
            default = "@rules_rust//proto/prostgen/raze/cargo:prost_types",
        ),
        "structopt": attr.label(
            doc = "The location of the structopt Rust library.",
            default = "@rules_rust//proto/prostgen/raze/cargo:structopt",
        ),
        "thiserror": attr.label(
            doc = "The location of the thiserror Rust library.",
            default = "@rules_rust//proto/prostgen/raze/cargo:thiserror",
        ),
        "tonic_build": attr.label(
            doc = "The location of the tonic_build Rust library.",
            default = "@rules_rust//proto/prostgen/raze/cargo:tonic_build",
        ),
        "protoc": attr.label(
            doc = "The location of the `protoc` binary. It should be an executable target.",
            executable = True,
            cfg = "exec",
            default = Label("@com_google_protobuf//:protoc"),
        ),
    },
    toolchains = ["//proto/prostgen:toolchain"],
    doc = """\
Declares a Rust Prost+Tonic toolchain for use.

This is used to configure proto compilation used by the Prost compiler plugin. This is
usually to avoid having two conflicting versions of Tonic and other related, downstream
libraries if your repo has its own Cargo Raze setup.

Example:

Suppose you have a repo using Cargo Raze with its own version of Tonic. You can setup
the Prost+Tonic rules to use it by doing:

```python
load('@rules_rust//proto/prostgen:toolchain.bzl', 'rust_prostgen_toolchain')

rust_prostgen_toolchain(
   name="rust_prostgen_impl",
   anyhow="//rust/raze:anyhow",
   heck="//rust/raze:heck",
   prost="//rust/raze:prost",
   prost_build="//rust/raze:prost_build",
   prost_types="//rust/raze:prost_types",
   structopt="//rust/raze:structopt",
   thiserror="//rust/raze:thiserror",
   tonic_build="//rust/raze:tonic_build",
   protoc="@com_google_protobuf//:protoc",
)

toolchain(
    name="rust_prostgen",
    exec_compatible_with = [
        "@platforms//cpu:cpuX",
    ],
    target_compatible_with = [
        "@platforms//cpu:cpuX",
    ],
    toolchain = ":rust_prostgen_impl",
)
```

Then, either add the label of the toolchain rule to register_toolchains in the WORKSPACE, or pass \
it to the `--extra_toolchains` flag for Bazel, and it will be used.
""",
)
