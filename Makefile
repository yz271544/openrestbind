VERSION=$(shell git describe --tags)
.PHONY: version
version:
	@echo ${VERSION}


REPO ?= registry.cn-beijing.aliyuncs.com/dc_huzy

.PHONY: jingwei-frontend-amd64
jingwei-frontend-amd64:
	@./release.sh ${VERSION}
	docker buildx build --platform linux/amd64 --no-cache -t ${REPO}/jingwei-frontend-amd64:${VERSION} --build-arg VERSION=${VERSION} -f Dockerfile .

.PHONY: jingwei-frontend-arm64
jingwei-frontend-arm64:
	@./release.sh ${VERSION}
	docker buildx build --platform linux/arm64/v8 --no-cache -t ${REPO}/jingwei-frontend-arm64:${VERSION} --build-arg VERSION=${VERSION} -f arm64.dockerfile .

.PHONY: images
images: jingwei-frontend-amd64 jingwei-frontend-arm64

.PHONY: push
push:
	docker push ${REPO}/jingwei-frontend-amd64:${VERSION}
	docker push ${REPO}/jingwei-frontend-arm64:${VERSION}
