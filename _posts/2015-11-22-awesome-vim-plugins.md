---
title: Awesome vim plugins
tags: [Vim]
---

偶然看了一下邮箱里面的第一封邮件，是一个自解压的vim压缩包，日期是2011年5月28日，思绪一下飘到了大学时代。。。

四年过去了。。。:sob:

so,来推荐vim插件吧:smile:

## splitjoin.vim

<https://github.com/AndrewRadev/splitjoin.vim>

> 在工作中经常需要进行各种结构的单行和多行的转换，现在用gS和gJ来做这件事吧。

* 单行的ruby表达式转换成多行(gS)

``` ruby
puts "foo" if bar?
```

``` ruby
if bar?
  puts "foo"
  puts "baz"
end
```



* 单行html转换成多行，太需要这个了！(gS)

``` html
<div id="foo">bar</div>
```

``` html
<div id="foo">
  bar
</div>
```

## vim-plug

  <https://github.com/junegunn/vim-plug>

  > 轻量级的Vim Plugin Manager，能并行更新插件,速度很快

  ![](https://raw.githubusercontent.com/junegunn/i/master/vim-plug/installer.gif)

## ctrl-p

  <https://github.com/kien/ctrlp.vim>

  > 最离不开的插件，fuzzy-find, buffer-list

  ![](https://camo.githubusercontent.com/0a0b4c0d24a44d381cbad420ecb285abc2aaa4cb/687474703a2f2f692e696d6775722e636f6d2f7949796e722e706e67)

## indentLine

  <https://github.com/Yggdroot/indentLine>

  > 有个indentline看起来好多了

  ![](/assets/images/indentline.png)


## vim-easy-align

  <https://github.com/junegunn/vim-easy-align>

> 强迫症必备

  ![Alt text here](https://raw.githubusercontent.com/junegunn/i/master/easy-align/equals.gif)


## tcomment_vim

  <https://github.com/tomtom/tcomment_vim>

> 用过很多注释插件，这个应该是最好的，能识别嵌套的文件类型（比如html里面的js代码）



## vim-airline

  <https://github.com/bling/vim-airline>

> 轻量级的powerline，很漂亮

  ![](https://github.com/bling/vim-airline/wiki/screenshots/demo.gif)

  ![](https://f.cloud.github.com/assets/306502/962204/cfc1210a-04eb-11e3-8a93-42e6bcd21efa.png)
