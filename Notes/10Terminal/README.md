# 终端编译运行
在终端编译运行oc

## 1. gcc编译链接
```
// Foundation表示你要使用的框架, files表示一序列将要编译的文件, 若编译正确则生成可执行文件名为progname
gcc -framework Foundation files -o progname
// 执行这个程序，将./放在程序名前表示在当前目录查找
./progname
```

## 2. nc连接监听tcp和udp
* nc -lk port监听连接port端口号

