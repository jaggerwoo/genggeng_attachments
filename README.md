# GenggengAttachments

Rails多附件上传功能, 
依赖:
- 'simple_form', "~> 3.2.1"
- 'carrierwave', "~> 0.10"
- 'mini_magick'
- 'jquery-fileupload-rails'
- 'turbolinks'

## Installation

1. 修改 Gemfile 增加:

```bash
# Gemfile
# gem 'genggeng_attachments'
gem 'genggeng_attachments', :git => 'git@github.com:WadeJG/genggeng_attachments.git', :branch => 'master'
    
$ bundle
```

2. 生成基本配置文件：


```bash
$ rails g genggeng_attachments:install

then, add js file included 
    
//= require genggeng_attachments/application

add css file included 

*= require genggeng_attachments/application
```

3. 自定义配置

```ruby

modify config/initializes/genggeng_attachments.rb

GenggengAttachments.configure do
  self.upload_limit_nubmer = 3
end
```

4. 在对应model中增加关联关系

```ruby

has_many :genggeng_attachments, as: :genggeng_attachmentable

```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

