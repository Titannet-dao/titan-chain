# Makefile

# 动态获取版本号和 Git 提交哈希
VERSION := $(shell echo $(shell git describe --tags) | sed 's/^v//')
COMMIT := $(shell git rev-parse --short HEAD)

# 默认构建标签
build_tags = netgo

# Ledger支持检查
ifeq ($(LEDGER_ENABLED),true)
  ifeq ($(OS),Windows_NT)
    GCCEXE = $(shell where gcc.exe 2> NUL)
    ifeq ($(GCCEXE),)
      $(error gcc.exe not installed for ledger support, please install or set LEDGER_ENABLED=false)
    else
      build_tags += ledger
    endif
  else
    UNAME_S = $(shell uname -s)
    ifeq ($(UNAME_S),OpenBSD)
      $(warning OpenBSD detected, disabling ledger support (https://github.com/cosmos/cosmos-sdk/issues/1988))
    else
      GCC = $(shell command -v gcc 2> /dev/null)
      ifeq ($(GCC),)
        $(error gcc not installed for ledger support, please install or set LEDGER_ENABLED=false)
      else
        build_tags += ledger
      endif
    endif
  endif
endif

# LevelDB支持检查
ifeq ($(WITH_CLEVELDB),yes)
  build_tags += gcc
endif

# 合并用户指定的构建标签
build_tags += $(BUILD_TAGS)
build_tags := $(strip $(build_tags))
BUILD_TAGS_COMMA_SEP := $(subst $(space),$(comma),$(build_tags))

# 二进制名称和目标目录
BINARY_NAME := titand
INSTALL_DIR := /usr/local/bin
GO_CMD := go

# 默认目标
all: clean build install

# 清理旧的二进制文件
clean:
	@echo "Cleaning old binaries..."
	@rm -f $(INSTALL_DIR)/$(BINARY_NAME)

# 编译 titand
build:
	@echo "Building $(BINARY_NAME)..."
	$(GO_CMD) build -ldflags \
		"-X github.com/cosmos/cosmos-sdk/version.Name=titan \
		-X github.com/cosmos/cosmos-sdk/version.AppName=$(BINARY_NAME) \
		-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
		-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) \
		-X 'github.com/cosmos/cosmos-sdk/version.BuildTags=$(BUILD_TAGS_COMMA_SEP)'" \
		-o $(BINARY_NAME) ./cmd/$(BINARY_NAME)

# 安装到 /usr/local/bin
install: build
	@echo "Installing $(BINARY_NAME) to $(INSTALL_DIR)..."
	@install -m 0755 $(BINARY_NAME) $(INSTALL_DIR)

# 帮助信息
help:
	@echo "Available targets:"
	@echo "  clean   - Remove old binaries"
	@echo "  build   - Compile $(BINARY_NAME)"
	@echo "  install - Install $(BINARY_NAME) to $(INSTALL_DIR)"
	@echo "  all     - Clean, build, and install"
	@echo "  help    - Display this help message"
