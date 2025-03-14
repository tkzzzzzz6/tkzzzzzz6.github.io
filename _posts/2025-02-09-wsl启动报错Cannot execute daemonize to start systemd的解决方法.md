---
title: WSL 启动报错 "Cannot execute daemonize to start systemd" 的解决方法
tags: 问题解决
---

## 问题背景
在启动 WSL2 时遇到以下错误：  
`Cannot execute daemonize to start systemd`  

![报错截图](https://fastly.jsdelivr.net/gh/tkzzzzzz6/imagehost@main/blog/17390777698341739077769078.png)

> 解决思路来源:https://github.com/DamionGans/ubuntu-wsl2-systemd-script/issues/37

此错误通常是因为 **`daemonize`** 工具未正确安装或配置导致。  
`daemonize` 是一个 Linux 工具，用于将普通程序转换为守护进程（后台服务），而 `systemd` 作为系统和服务管理器需要依赖此工具。

---


## 解决方法

### 1. 检查 daemonize 是否安装
1. **以 root 身份登录 WSL**：  
   在 Windows 的 CMD 或 PowerShell 中执行：  
   ```bash
   wsl -u root
   ```

2. **验证 daemonize 是否存在**：  
   ```bash
   which daemonize
   ```
   - 如果无输出，则表示未安装。

---

### 2. 安装 daemonize
#### 步骤一：更新软件源
```bash
sudo apt update
```

#### 步骤二：尝试安装 daemonize
```bash
sudo apt install daemonize
```

---

### 3. 处理安装报错 `E: Unable to locate package daemonize`
若出现此错误，可能是软件源未正确配置。需手动更新软件源：

#### 方案一：使用 Ubuntu 官方源（推荐国际用户）
```bash
sudo sh -c 'echo "deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list'
sudo sh -c 'echo "deb http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list'
sudo sh -c 'echo "deb http://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list'
sudo sh -c 'echo "deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list'
```

#### 方案二：使用国内镜像源（推荐中国用户）
例如替换为清华源：  
```bash
sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
```

#### 更新并安装
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install daemonize
```

---

### 4. 验证安装并重启 WSL
1. **确认 daemonize 路径**：  
   ```bash
   which daemonize  # 应输出 /usr/bin/daemonize
   ```

2. **重启 WSL**：  
   关闭 WSL 并重新启动：  
   ```bash
   wsl --shutdown
   wsl
   ```

---

## 补充说明
### 为什么需要 systemd？
- `systemd` 是 Linux 系统的初始化系统，管理后台服务（如 SSH、Docker 等）。
- WSL2 默认不启用 systemd，但部分工具（如 Docker Desktop、snap）依赖它。

### 可选：永久启用 systemd
若需在 WSL 中默认启用 systemd，可修改 `/etc/wsl.conf`：  
```bash
sudo tee /etc/wsl.conf <<EOF
[boot]
systemd=true
EOF
```
重启 WSL 生效：  
```bash
wsl --shutdown
wsl
```

---

## 常见问题
#### Q1: 安装后仍报错怎么办？
- 确认 `daemonize` 路径在 `/usr/bin` 中。
- 检查 WSL 版本是否为 WSL2：`wsl -l -v`。

#### Q2: 修改软件源后无法更新？
- 备份原始源文件：`sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak`。
- 检查网络连接：`ping archive.ubuntu.com`。

---

## 总结
通过安装 `daemonize` 并正确配置软件源，可解决 `Cannot execute daemonize to start systemd` 错误。若需进一步使用 systemd 相关服务，建议通过 `/etc/wsl.conf` 启用 systemd 支持。