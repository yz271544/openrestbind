VERSION=$(shell git describe --tags)
.PHONY: version
version:
	@echo ${VERSION}


REPO ?= registry.cn-beijing.aliyuncs.com/dc_huzy

.PHONY: images
images:
	@./release.sh ${VERSION}
	docker buildx build --platform linux/amd64,linux/arm64 -t ${REPO}/jingwei-frontend:${VERSION} --build-arg VERSION=${VERSION} -f Dockerfile --push .

