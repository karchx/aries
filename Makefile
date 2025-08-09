run:
	podman run -it --rm --mount type=bind,source=$(pwd),target=/workdir cross-i686

