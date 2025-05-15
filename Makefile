VERSION=$(shell git describe --tags)
.PHONY: version
version:
	@echo ${VERSION}


REPO ?= registry.cn-beijing.aliyuncs.com/dc_huzy

.PHONY: jingwei-frontend-amd64
jingwei-frontend-amd64:
	@./release.sh ${VERSION}
	docker buildx build --platform linux/amd64 -t ${REPO}/jingwei-frontend-amd64:${VERSION} --build-arg VERSION=${VERSION} -f Dockerfile . --load

.PHONY: jingwei-frontend-arm64
jingwei-frontend-arm64:
	@IMAGE_HASH=$(docker inspect --format='{{.Id}}' openresty/openresty:1.27.1.2-bookworm-fat-aarch64 | cut -d':' -f2)
	@echo "IMAGE_HASH:${IMAGE_HASH}"
	@./release.sh ${VERSION}
	docker buildx build --platform linux/arm64/v8 -t ${REPO}/jingwei-frontend-arm64:${VERSION} --build-arg VERSION=${VERSION} -f arm64.dockerfile . --load

.PHONY: images
images: jingwei-frontend-amd64 jingwei-frontend-arm64

.PHONY: push
push:
	docker push ${REPO}/jingwei-frontend-amd64:${VERSION}
	docker push ${REPO}/jingwei-frontend-arm64:${VERSION}
