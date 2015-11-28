---
title: Linkedin Authenticating with OAuth 2.0
tags: [OAuth]
---

<p class="lead">
一直对oauth授权机制很模糊，最近工作中需要使用linkedin api，就仔细学习了一下。
代码使用oauth2 gem。
</p>
<https://github.com/intridea/oauth2>

## 配置application

<https://www.linkedin.com/developer/apps/new>

获得`client_id`, `client_secret`
这里还有`redirect_uri`需要设置。

## 获取Authorization Code

- `GET` https://www.linkedin.com/uas/oauth2/authorization

```ruby
client = OAuth2::Client.new('client_id', 'client_secret', site: 'https://example.org')
client.auth_code.authorize_url(redirect_uri: 'http://localhost/oauth2/callback')
# https://www.linkedin.com/uas/oauth2/authorization?client_id=74x467dun7ceu7&redirect_uri=http%3A%2F%2Flocalhost%2Foauth2%2Fcallback&response_type=code&state=12345
```


url中包含下面几个参数

```
client_id: 74x467dun7ceu7
redirect_uri: http://localhost/oauth2/callback
response_type: code
state: 12345
```

在浏览器中打开上面的url

![](https://content.linkedin.com/content/dam/developer/global/en_US/site/img/authorization_dialog.jpg)

授权之后会跳转到redirect_uri, 并且包含下面两个参数

```
code: The OAuth 2.0 authorization code。
state: state，检查和上面指定值是否一致，用来防范CSRF攻击。
```

## 交换Authorization Code 得到 Request Token


- `POST` https://www.linkedin.com/uas/oauth2/accessToken

参数说明：

<table>
<tbody>
<tr>
<td>Parameter</td><td>Description</td><td>Required</td></tr>
<tr>
<td>grant_type</td><td>值为:&nbsp; authorization_code<br></td><td>Yes</td></tr>
<tr>
<td>code</td><td>上一步获取的code<br></td><td>Yes</td></tr>
<tr>
<td>redirect_uri</td><td>上一步一样的redirect_uri<br></td><td>Yes</td></tr>
<tr>
<td>client_id</td><td>client id</td><td>Yes</td></tr>
<tr>
<td>client_secret</td><td>client secret</td><td>Yes</td></tr></tbody></table>

post返回的响应中包含两个参数:

```
access_token: 我们需要的access_token,请求被保护的api时需要此参数。
expires_in: token的过期时间。
```

```ruby
token = client.auth_code.get_token(code, redirect_uri: redirect_uri)
```

## 发送已授权的请求

* `GET` /api/resource

```ruby
token.get('/api/resource', :params => { 'query_foo' => 'bar' })
```

参考：
<https://developer.linkedin.com/docs/oauth2>
