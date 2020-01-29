modules = $(shell find . -type f -name "*.tf" -exec dirname {} \;|sort -u)

.PHONY: test
-backend=false
default: test

init:
	@for m in $(modules); do (terraform init -backend=false "$$m" && echo "√ $$m") || exit 1 ; done

validate:
	@for m in $(modules); do (terraform validate "$$m" && echo "√ $$m") || exit 1 ; done

fmt:
	@if [ `terraform fmt | wc -c` -ne 0 ]; then echo "terraform files need be formatted"; exit 1; fi