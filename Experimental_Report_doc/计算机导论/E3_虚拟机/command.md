# 1.cd 命令
```sh
cd [dirName]

cd /path/to/directory

cd relative/path/to/directory

cd /usr/bin

cd ..
cd ../../   // 切换到上上级目录

cd ~

cd -

cd $VAR_NAME

```


# 2.ls 命令
```sh
ls [-alrtAFR] [name...]

ls -l                    # 以长格式显示当前目录中的文件和目录
ls -a                    # 显示当前目录中的所有文件和目录，包括隐藏文件
ls -lh                   # 以人类可读的方式显示当前目录中的文件和目录大小
ls -t                    # 按照修改时间排序显示当前目录中的文件和目录
ls -R                    # 递归显示当前目录中的所有文件和子目录
ls -l /etc/passwd        # 显示/etc/passwd文件的详细信息

ls "my file.txt"    # 列出文件名为"my file.txt"的文件
ls my\ file.txt     # 列出文件名为"my file.txt"的文件
ls -- -filename     # 列出文件名为"-filename"的文件

-rw-r--r-- 1 user group 4096 Feb 21 12:00 file.txt
```

# 3.mkdir 命令

```sh
mkdir [-p] dirName

mkdir runoob

mkdir -p runoob2/test

```

# 4.rm 命令

```sh
rm [options] name...

# rm  test.txt 
rm：是否删除 一般文件 "test.txt"? y  
# rm  homework  
rm: 无法删除目录"homework": 是一个目录  
# rm  -r  homework  
rm：是否删除 目录 "homework"? y 

rm  -r  * 

```

# 5.rmdir 命令

```sh
rmdir [-p] dirName

rmdir AAA

rmdir -p BBB/Test
```

# 6.cp 命令

```sh
cp [options] source dest
或
cp [选项] 源文件 目标文件
 
 cp file.txt /path/to/destination/

 cp file.txt /path/to/destination/newfile.txt

 cp -r /path/to/source_dir /path/to/destination/

 cp -i file.txt /path/to/destination/

 cp -p file.txt /path/to/destination/

 cp -u file.txt /path/to/destination/

 cp -v file.txt /path/to/destination/

 cp -l file.txt /path/to/destination/  # 创建硬链接
cp -s file.txt /path/to/destination/  # 创建符号链接

cp file1.txt file2.txt /path/to/destination/

cp *.txt /path/to/destination/

find /path/to/source -name "*.log" -exec cp {} /path/to/destination/ \;

```

> 注意事项
- 如果目标路径是一个目录，cp 会将源文件或目录复制到该目录中。

- 如果目标路径是一个文件名，cp 会将源文件复制并重命名为目标文件名。

- 复制目录时，必须使用 -r 或 -R 选项，否则会报错。

- 如果目标文件已存在，默认情况下 cp 会覆盖它（除非使用 -i 选项）。

# 7.find 命令
```sh
find [路径] [匹配条件] [动作]

find . -name file.txt

# find . -name "*.c"

# find . -type f

find /home -size +1M

find /var/log -mtime +7

find /path/to/search -atime -7

# find . -ctime  20

# find . -ctime  +20

# find /var/log -type f -mtime +7 -ok rm {} \;

# find . -type f -perm 644 -exec ls -l {} \;

# find / -type f -size 0 -exec ls -l {} \;

find /path/to/search -name "pattern" -exec rm {} \;

```
# 8.vi/vim
```sh
vim runoob.txt

```

# 9.yum 命令
```sh
yum [options] [command] [package ...]

# 1. 列出所有可更新的软件清单
yum check-update

# 2. 更新所有软件
yum update

# 3. 安装指定软件
yum install <package_name>

# 4. 更新指定软件
yum update <package_name>

# 5. 列出所有可安装的软件清单
yum list

# 6. 删除软件包
yum remove <package_name>

# 7. 查找软件包
yum search <keyword>

# 8. 清除缓存相关命令
yum clean packages        # 清除缓存目录下的软件包
yum clean headers        # 清除缓存目录下的 headers
yum clean oldheaders     # 清除缓存目录下旧的 headers
yum clean               # 清除缓存目录下的软件包及旧的 headers
yum clean all           # 清除缓存目录下的软件包及旧的 headers

```
