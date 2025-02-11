VERSION = 6.19.3
REL = $(VERSION)-1
THREADS = $(shell nproc)
PRIORITY = 0
REPO=docker.io/metal3d/xmrig
CC=podman

HUB=https://hub.docker.com/v2

all: build run

build:
	$(CC) build -t $(REPO):$(REL) --build-arg VERSION=$(VERSION) .
	$(CC) tag $(REPO):$(REL) $(REPO):latest

run:
	$(CC) run --rm -it -e THREADS=$(THREADS) -e PRIORITY=$(PRIORITY) $(REPO):$(REL)


deploy: build
	$(CC) push $(REPO):$(REL)
	$(CC) push $(REPO):latest

test:

.ONESHELL:
set-description:
ifdef PASSWORD
	@echo "Changing description"
	token=`http $(HUB)/users/login username=$(USERNAME) password=$(PASSWORD) | jq -r '.token'`
	http --form PATCH  $(HUB)/repositories/metal3d/xmrig/ Authorization:"JWT $$token" full_description=@README.md 
else
	@echo "You need to provide repo password in PASSWORD variable argument"
endif
