
publish:
	rm -rf pkg/core/.imgpkg
	mkdir -p pkg/core/.imgpkg
	kbld -f pkg/core/config --imgpkg-lock-output pkg/core/.imgpkg/images.yml
	imgpkg push --bundle ghcr.io/pichuang/tkg-core --file pkg/core

clean:
	rm -rf repo pkg/core/.imgpkg
