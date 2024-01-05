# alfred-splitscreen-workflow
alfred-splitscreen-workflow

依赖 https://github.com/jakehilborn/displayplacer

！！！注意：这就是我自己用的，不保证后向兼容，请fork使用

## 一些命令

```
pm 配置名
    将当前窗口调整到主屏幕中，配置名指定大小位置
pd 配置名
    将当前窗口调整到扩展屏幕中，配置名指定大小位置
po 配置名
    将当前窗口调整到另一块屏幕中，配置名指定大小位置
pc 配置名
    将当前窗口调整到当前屏幕中，配置名指定大小位置
cc x y width height
    将当前窗口调整到当前屏幕中，指定的大小位置
co x y width height
    将当前窗口调整到另一块屏幕中，指定的大小位置
pshow 配置名
    查看指定配置的大小位置
pdef 配置名 x y width height
    定义配置（会覆盖）
```

## 配置文件split-screen.csv

格式：配置名 x y width height

```
left 0 0 49 100
right 51 0 49 100
top 0 0 100 49
```
