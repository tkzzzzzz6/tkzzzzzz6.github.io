Colab + VS Code + Google Drive 配套脚本
记录日期：2026-11-08

用途
在指定 Colab 运行时挂载 Google Drive，建立共享工作目录，并让本地
VS Code Remote SSH 打开 /content/workspace。

文件
- Open-ColabWorkspace.ps1：Windows 本地 PowerShell 启动入口。
- Check-Drive.py：通过 colab exec 在远端检查挂载状态。
- Initialize-Workspace.py：通过 colab exec 在远端初始化共享目录。
- ssh-config.example：Windows OpenSSH 的通用配置示例。
- ssh-config.unix.example：Linux/macOS OpenSSH 的通用配置示例。

前提
1. 本地安装 OpenSSH 客户端、VS Code 和 Remote SSH 扩展。
   Windows 启动脚本使用 PowerShell 7；Linux/macOS 使用下方终端命令。
2. 安装 Colab CLI，并完成该版本要求的 Google 身份认证。
3. 本次使用 google-colab-cli 0.7.5；官方 README 尚未声明支持 Windows。
   新版本命令和输出可能变化，请先核对 colab --help。
4. 已有权限正确的 ~/.ssh/id_ed25519 密钥。
5. 账号有使用对应 Colab 运行时和 SSH 的权限及可用额度。

首次准备
1. 将本压缩包解压到同一目录，例如：
   Windows：%USERPROFILE%\Documents\Colab
   Linux/macOS：$HOME/Documents/Colab
2. 阅读与本地系统对应的配置文件，把需要的 Host 配置合并到：
   Windows：ssh-config.example → %USERPROFILE%\.ssh\config
   Linux/macOS：ssh-config.unix.example → ~/.ssh/config
   不要覆盖原有配置。如果已有同名 Host，请修改原有条目，避免重复。
3. Windows 用 Get-Command colab、Get-Command code 检查本机命令。
   Linux/macOS 用 command -v colab、command -v code 检查本机命令。
4. 如果密钥路径不同，请同时修改 IdentityFile 与 ProxyCommand 的 --identity。
5. Windows 配置使用 NUL；Linux/macOS 配置使用 /dev/null。
   两者均放宽主机密钥校验，适用于文章中的临时运行时取舍。

Windows 运行
在本地 PowerShell 7 中执行：

  & "$env:USERPROFILE\Documents\Colab\Open-ColabWorkspace.ps1" -Session colab

colab 基础入口要求会话已存在。其他入口为：
colab-g4、colab-h100、colab-a100、colab-l4、colab-t4。
这些 GPU 入口在会话不存在时自动申请对应 GPU，开始消耗运行时资源：

  & "$env:USERPROFILE\Documents\Colab\Open-ColabWorkspace.ps1" -Session colab-g4

已存在的会话会被复用，脚本不会把其 GPU 原地改成另一种型号。
连接后请运行 nvidia-smi 核对实际设备。
若出现 Drive 授权链接，选择同一个 Google 账号，授权后回到终端按 Enter。
不要把授权码、密钥、认证配置或授权链接发给其他人。

可选参数
-NoOpen：准备完成后不启动 VS Code。
-NoMount：没有挂载时直接报错，不发起交互授权。
这两个参数都不会禁止缺失 GPU 会话的自动创建，不是 dry-run 模式。

Linux/macOS 运行
先根据需要创建会话，例如（已有会话时跳过）：

  colab new -s colab-g4 --gpu G4

在本地终端中执行：

  session=colab-g4
  colab drivemount -s "$session" /content/drive
  colab exec -s "$session" --timeout 180 -f "$HOME/Documents/Colab/Initialize-Workspace.py"

选择同一个 Google 账号完成 Drive 授权。初始化成功并输出
COLAB_WORKSPACE_READY=1 后，执行：

  code --remote "ssh-remote+$session" /content/workspace

此手动流程会输出远端工作区标识，但不会自动和本地保存的 UUID 比较。
请自行核对不同运行时的标识，确认连接到同一工作区。

目录
持久目录：/content/drive/MyDrive/ColabWorkspace
运行时入口：/content/workspace（指向上述目录的软链接）
子目录：code、data、models、checkpoints、outputs、env。

脚本先验证真实挂载点，再创建目录。已有项目文件不会被覆盖。
如果 /content/workspace 已存在且不是预期软链接，脚本停止并保留原内容。
env/requirements.txt 初始只有注释，需要填写项目的实际依赖版本。
每个新运行时都需要安装依赖，可在远端执行：

  bash /content/workspace/env/bootstrap.sh

工作区标识
初始化会在云盘 env/workspace-id.txt 中记录工作区 UUID，并在本地脚本目录
保存对应的 workspace-id.txt。后续运行发现标识不同，会在打开 VS Code 前
停止。这只是误挂载检查，不是账号认证或并发写入锁。
只有首次选择了正确云盘，后续比较才有正确基准。
如果主动更换工作区，请核对两边路径和内容，再备份本地标识并重新初始化。
压缩包不附带任何人的既有工作区标识。

训练与数据
挂载相同目录不等于恢复进程、Python 环境或训练状态。
切换 GPU 前保存完整检查点并等待云盘同步；在新会话中显式恢复训练。
不同任务使用不同输出目录，避免同时写入同一模型或检查点。
大量小文件和频繁读写可能受 Drive I/O 限制，必要时使用 /content 本地缓存。
关闭 VS Code 不会自动停止 Colab 运行时。

本次验证范围
当前 colab 会话的 SSH、VS Code、Drive 挂载和共享目录已跑通。
五种 GPU 的 SSH 配置完成了解析检查，没有逐卡完成挂载或微调性能测试。
Linux/macOS 配置已做语法解析；尚未在这两个系统上完整实测云端登录。
本包不包含私钥、账号凭据、机器专属快捷方式、日志或已有工作区 UUID。

参考
https://github.com/googlecolab/google-colab-cli
https://research.google.com/colaboratory/faq.html
https://code.visualstudio.com/docs/remote/ssh
