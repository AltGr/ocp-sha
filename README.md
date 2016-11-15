## ocp-SHA

Yet another implementation of the SHA256 and SHA512 hashing algorithms. This is
pure OCaml code, directly following the specification, and quick experiments
have shown it to be within a factor 10 of openssl, performance-wise. This may be
an acceptable compromise for many applications if you want to avoid linking C
code or calling external tools.

The implementation relies on bigarrays to minimise the number of in-memory
copies of the data to hash. The only entry point provided applies to a file
name, but others wouldn't be difficult to add: feel free to contribute if you
need them. SHA384 isn't included but would be trivial to add, as it is almost
identical to SHA512.

There are no dependencies besides the standard libs unix and bigarray.

Copyright 2016 OCamlPro.
ocp-SHA is distributed under the terms of the GNU Lesser General Public License
version 2.1, with the special exception on linking describted in the file
LICENSE.
