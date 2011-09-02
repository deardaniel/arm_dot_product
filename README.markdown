Assignment &mdash; Implementation of dot product calculation on ARM
===================================================================


This is iOS project to demonstration ARMv6 and ARMv7 (using NEON) assembly programming.

Currently all floating point operations are dependent on NEON and therefore do not compile for ARMv6. However, integer-based calculations work fine.

The code is primarily in `ARM/dot_product.s`, with `main.m` providing some benchmarking functionality.

The project is documented in `Report/arm_report.tex`, which is also available as a [pdf download](https://github.com/downloads/deardaniel/arm_dot_product/arm_report.pdf) on this GitHub page.
