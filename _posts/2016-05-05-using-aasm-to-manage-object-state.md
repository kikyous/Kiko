---
title: "使用AASM管理对象状态"
tags: [rails]
---

* TOC
{:toc}

某库存系统项目，有`公司`和`库存`两种模型，一个公司有多个产品的库存信息。

```ruby
class Company
  has_many :stocks
end
```
```ruby
class Stock
  belongs_to :company
end
```

公司有`新建(pending)`和`激活(active)`两种状态，库存有`新建(pending)`，`已支付(paid)`和`激活(active)`3种状态，公司的状态会影响库存状态。

库存信息支付后状态变为已支付，然后激活公司，库存信息状态变为激活。
若公司从激活变为未激活，已支付的库存信息状态从激活变为已支付。

在最早期的实现里，状态的控制都是手动完成，整个流程都很混乱，要引入新的状态非常困难。

后来经过重构，使用aasm来管理这些状态。

<https://github.com/aasm/aasm>

# 使用AASM管理状态

## 公司(Company)

```ruby
class Company
  has_many :stocks
  aasm :column => :state, :whiny_transitions => false do
    state :pending, :initial => true
    state :active

    event :up do
      transitions :from => :pending, :to => :active,
        if: :company_actived?, success: ->{ stocks.each(&:up!) }
    end

    event :down do
      transitions :from => :active, :to => :pending,
        unless: :company_actived?, success: ->{ stocks.each(&:down!) }
    end
  end

  def company_actived?
    # ...
  end
end
```

* 两种状态:
  * `pending`
  * `active`
* 两个事件:
  * `up`事件首先会检查公司是否具备激活的条件`company_actived?`，若返回真则公司的状态从`pending`转变为`active`，执行成功后会在此公司的所有库存信息上执行up事件。

  * `down`事件首先会检查公司是否已经不具备激活的条件`company_actived?`，若返回假则公司的状态从`active`转变为`pending`，执行成功后会在此公司的所有库存信息上执行down事件。

## 库存(Stock)

```ruby
class Stock
  belongs_to :company
  aasm :column => :state, :whiny_transitions => false do
    state :pending, :initial => true
    state :paid
    state :active

    event :pay do
      transitions :from => :pending, :to => :active, if: :company_active?
      transitions :from => :pending, :to => :paid
    end

    event :up do
      transitions :from => :paid, :to => :active, if: :company_active?
    end

    event :down do
      transitions :from => :active, :to => :paid, unless: :company_active?
    end

  end

  def company_active?
    company.active?
  end
end
```

* 三种状态:
  * `pending`
  * `paid`
  * `active`
* 三个事件:
  * `pay`事件在支付成功后执行，有下面两种情况:
    * 若公司已激活(`company_active?`为真)，则库存的状态转换为`active`
    * 若公司未激活，则库存的状态转换为`paid`
  * `up`事件在公司的up事件里被调用，若此时公司已激活，则库存状态从`paid`转变为`active`，否则什么都不发生
  * `down`事件在公司的down事件里被调用，若此时公司未激活，库存状态从`active`转变为`paid`，否则什么都不发生

经过这样的重构后整个流程变得清晰明了，只需要在适当的地方调用定义好的事件就可以了，我们的目的达到了:smile:
