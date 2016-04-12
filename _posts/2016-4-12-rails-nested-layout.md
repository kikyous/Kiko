---
title: Rails nested layout
tags: [rails]
---

# 问题

* 某rails项目 `layouts/application.html.erb`

```erb
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= @title  %></title>
    <meta name="keywords" content="<%= @keywords %>" />
    <meta name="description" content="<%= @description %>" />
    <%= csrf_meta_tags %>
    <%= action_cable_meta_tag %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
  </head>
  <body>
    <%= yield %>
    <footer>
      ...
    </footer>
  </body>
</html>
```

现在需要另一个子layout，他`继承`自layouts/application.html.erb，又有自己的内容，该怎么办呢？尽量把公共的部分抽出来，然后在不同的layout之间共享吗？

* `layouts/main.html.erb`

```erb
<!DOCTYPE html>
<html>
  <%= render 'head' %>
  <body>
    <div class="container">
      <%= yield %>
      <div class="sidebar">
        ...
      </div>
    </div>
    <%= render 'footer' %>
  </body>
</html>
```

这样可以解决问题但不完美，没有体现出`继承`关系来，如果layout复杂，可能需要抽出很多的共享部分出来，而且子模板还是有很多重复的代码。

# 嵌套模板

在`application_helper.rb`中加入下面的方法:

```ruby
def parent_layout(layout)
  @view_flow.set(:layout, output_buffer)
  output = render(:file => "layouts/#{layout}")
  self.output_buffer = ActionView::OutputBuffer.new(output)
end
```

然后`layouts/main.html.erb`就可以变成这样的了

```erb
<div class="container">
  <%= yield %>
  <div class="sidebar">
    ...
  </div>
</div>

<% parent_layout "application" %>
```

直接在子模板中指定父模板，完美的继承关系，而且可以进行多次，比如

* `layouts/profile.html.erb`

```erb
<div class="profile">
  <%= render 'profile_nav' %>
  <%= yield %>
</div>

<% parent_layout "main" %>
```

最后这3个layout的关系如下：

`application < main < profile`

# Reference
<http://m.onkey.org/nested-layouts>
