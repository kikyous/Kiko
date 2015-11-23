---
title: Laravel mail preview using dependency injection
tags: [php, laravel, mail preview]
---

<p class="lead">
laravel中需要发送邮件，邮件的样式调试每次都要重新发送邮件，效率很低，所以就想能不能不发送直接预览邮件。
</p>

## 如何预览邮件
```php
<?php
class NewUserRegisted implements ShouldQueue
{
    private $mailer;

    public function __construct(Mailer $mailer)
    {
      $this->mailer = $mailer;
    }

    public function handle(User $user)
    {
        $params1 = 'some var';
        $params2 = 'some var 2';
        return $this->mailer->send('emails.user_registed', compact('user', 'params1', 'params2'), function ($m) use ($user) {
            $m->to($user->email)->bcc('member@buyextracts.com')->subject('Welcome to register [www.buyextracts.com]');
        });
    }
}
```
上面的代码是新用户注册的事件监听器，只要把他和用户创建的事件进行绑定，当事件触发的时候邮件就会发送。
要进行邮件预览就要渲染`emails.user_registed`模版，而他所需要的数据由`handle`提供。
我们可以创建一个简单的控制器:

```php
<?php
class MailPreviewController extends Controller
{
    public function show(Request $request)
    {
        $params1 = 'some var';
        $params2 = 'some var 2';
        $user = User::first();

        $handle = $request->get('handle');
        return view('emails.user_registed', compact('user', 'params1', 'params2'));
    }
}
```
我们要做的只是提供必要的数据给模版， 但是如果他需要更多的数据呢？有没有更好的办法呢？

## 更好的方案

可以看到`NewUserRegisted`初始化的时候需要一个Mailer, Mailer实例的send方法负责发送邮件，那我们可不可以让send来进行模版渲染然后返回请求给浏览器呢？

```php
<?php
namespace App;
class MailPreview implements \Illuminate\Contracts\Mail\Mailer
{
    public $view;
    public function raw($text, $callback){}
    public function failures(){}
    public function send($view, array $data, $callback)
    {
        $this->$view = $view;
        return view($view, $data);
    }
}
```
所以我们的控制器就变成这样了

```php
<?php
use App\MailPreview;
class MailPreviewController extends Controller
{
    public function show(Request $request, MailPreview $mailer)
    {
        $listener = App\Listeners\NewUserRegisted($mailer);
        $user = User::first();
        return $listener->handle($user);
    }
}
```
我们利用`NewUserRegisted@handle`来提供模版需要的所有数据，而不是重新实现一次他的逻辑。

*注意 `NewUserRegisted@handle` 中的`return`。*

## 依赖注入(dependency injection)

> 依赖注入让类不依赖某个特定的类，而是依赖某个接口或协议, 我们可以通过注入不同的类的来完成不同任务，从而让代码更加灵活。

在上面的例子中我们通过注入自定义的类`MailPreview`替代原先的`Illuminate\Contracts\Mail\Mailer`来实现邮件预览功能。
