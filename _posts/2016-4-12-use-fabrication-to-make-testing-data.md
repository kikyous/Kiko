---
title: 使用fabrication准备测试用数据
tags: [rails, testing]
---

* TOC
{:toc}

rails默认用fixture创建测试数据，但是fixture直接操作数据库，不能利用ActiveRecord，要创造复杂的数据时就会非常痛苦。
因此出现了fabrication， factory_giri 等，在这两者中我最终选择了fabrication，因为它更加灵活，更加优美。

<https://github.com/paulelliott/fabrication>

# 数据模型
```ruby
class Company
  has_many :stocks
  has_many :staffs
  has_many :users, through: :staffs
end
```
```ruby
class User
end
```
```ruby
class Product
  belongs_to :stock
end
```

```ruby
class Staff < ApplicationRecord
  belongs_to :user
  belongs_to :company
end
```
```ruby
class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :company
end
```

# 创建数据

## 初步

```ruby
# 定义 company Fabricator
Fabricator(:company) do
  name { SecureRandom.hex(5) }
  contacts { SecureRandom.hex(3) }
  phone '1111111'
end
```
```shell
irb(main):012:0> Fabricate(:company)
=> #<Company id: 980193688, name: "d153c213e4", contacts: "995add", phone: "1111111", created_at: "2016-04-29 01:40:26", updated_at: "2016-04-29 01:40:26">
```

## 关联关系

```ruby
# 定义 stock Fabricator
Fabricator(:stock) do
  product
  company
end
```

```ruby
Fabricator(:staff) do
  user
  company
end
```

```shell
irb(main):007:0> Fabricate(:stock)
  ...
  SQL (0.3ms)  INSERT INTO `products` (`name`, `created_at`, `updated_at`) VALUES ('44434bee4c', '2016-04-29 01:42:39', '2016-04-29 01:42:39')
  SQL (0.2ms)  INSERT INTO `companies` (`name`, `contacts`, `phone`, `created_at`, `updated_at`) VALUES ('01382eb7e5', '8569b3', '1111111', '2016-04-29 01:42:39', '2016-04-29 01:42:39')
  SQL (0.2ms)  INSERT INTO `stocks` (`product_id`, `company_id`, `created_at`, `updated_at`) VALUES (298488079, 980193691, '2016-04-29 01:42:39', '2016-04-29 01:42:39')
  ...

=> #<Stock id: 980193023, product_id: 298488079, company_id: 980193691, created_at: "2016-04-29 01:42:39", updated_at: "2016-04-29 01:42:39">
```

可以看到`Fabricate(:stock)`不仅生成了Stock记录，还生成了与其关联的Product和Company。

## 更复杂的

```ruby
Fabricator(:company) do
  name { SecureRandom.hex(5) }
  contacts { SecureRandom.hex(3) }
  phone '1111111'

  staffs(count: 2){ Fabricate(:staff){ role: :admin } }
  stocks(count: 3){ |attrs, i| Fabricate(:stock){ remark: "stock#{i}" } }
end
```

上面的Fabricator会生成了一个完备的公司，包括：

  - 2个staff，与每个staff关联的user
  - 3个stock, 与每个stock关联的product

## 继承

如果每次要生成一个完备的公司都要写上面一大堆，岂不是很烦恼！为什么不直接定义一个表示完备公司的Fabricator呢？这个Fabricator继承自Company Fabricator，理所当然。

```ruby
Fabricator(:complete_company, from: :company) do
  staffs(count: 2){ Fabricate(:staff){ role: :admin } }
  stocks(count: 3){ |attrs, i| Fabricate(:stock){ remark: "stock#{i}" } }
end
```

然后就可以使用`Fabricate(:complete_company)`来生成一个和上面一样的公司了。

# READ MORE

* <http://fabricationgem.org/>
* <https://github.com/paulelliott/fabrication-site/blob/master/source/index.markdown>
