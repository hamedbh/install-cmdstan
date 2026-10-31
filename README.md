# Installing cmdstan

Helper directory to install [cmdstan](https://mc-stan.org/docs/cmdstan-guide/). Makefile has the required targets:

- `install`: downloads the tarball from GitHub and compiles from source. Version number is specified in the Makefile itself.
- `check`: checks that the toolkit compiles correctly
- `test`: runs the test example of the Bernoulli model

When in doubt refer to the [installation instructions](https://mc-stan.org/docs/cmdstan-guide/installation.html): if something doesn't work it's probably because something changed there.

