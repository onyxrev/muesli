Muesli
======

Provides serialization of models into hashes with attribute whitelisting and authorization for passing to views or as an API response.

## ToDo Example

### TodoSerializer
```ruby
class TodoSerializer < Muesli::Serializers::Base
  @whitelisted_attributes = [
    :created_at,
    :due_at,
    :completed_at,
    :task,
    :priority
  ]
end
```

### Todo
```ruby
class Todo < ActiveRecord::Base
  def serializer
    TodoSerializer.new(self)
  end
end
```

### Use
```ruby
  irb(main):004:0> todo = Todo.first
  irb(main):005:0> todo.serializer.serialize

  => {:created_at => Tue, 28 June 2014 16:42:40 UTC +00:00, :due_at => Tue, 2 July 2014 16:42:40 UTC +00:00, :completed_at => nil, :task => "Mow the car.", :priority => 2}
```

## CanCan Support (Valentine Example)

### ValentineSerializer

```ruby
class ValentineSerializer < Muesli::Serializers::Base
  include Muesli::Adapters::CanCan

  @whitelisted_attributes = [
    :created_at,
    :codename
  ]

  def serialize
    serialized_hash = super

    # add private attributes only for the owner
    if can? :update, model
      serialized_hash.merge!(serialize_attributes([
        :crush_name,
        :favorite_candy
      ]))
    end

    serialized_hash
  end
end
```

### Valentine
```ruby
class Valentine < ActiveRecord::Base
  def serializer
    ValentineSerializer.new(self)
  end
end
```

### Use
```ruby
  irb(main):004:0> valentine = Valentine.first
  irb(main):005:0> serializer = valentine.serializer
  irb(main):006:0> serializer.serialize

  => {:created_at => Tue, 10 February 2014 16:42:40 UTC +00:00, :codename => "Whisper Smileface"}

  irb(main):007:0> serializer.for_user(user).serialize

  => {:created_at => Tue, 10 February 2014 16:42:40 UTC +00:00, :codename => "Whisper Smileface", :crush_name => "Steve Buscemi", :favorite_candy => "Macaroon"}
```

## Custom Attribute Serializers

Let's say you use the Money gem.  By default it serializes into a complicated, verbose structure.  Maybe you just want it to serialize to a plain integer of cents.  No problem.  Create a Museli attribute serializer like so:

```ruby
module Muesli
  module AttributeSerializers
    class Money
      def serialize
        @value.cents
      end
    end
  end
end
```

Now whenever Muesli encounters a Money class attribute it routes it through your serializer.  Let's say you want to be a little more sophisticated.  Money provides many methods.  Let's say you want to return the fractional value and the currency as a string:

```ruby
module Muesli
  module AttributeSerializers
    class Money
      def serialize
        {
          :currency   => @value.currency_as_string,
          :fractional => @value.fractional
        }
      end
    end
  end
end
```

You get the idea.  If you want to be really fancy you can hook your models up to full-blown serialiers:

```ruby
module Muesli
  module AttributeSerializers
    class Todo
      def serialize
        TodoSerializer.new(@value).serialize
      end
    end
  end
end
```

Now whenever Muesli encounters a Todo in your whitelisted attributes, it automatically uses the TodoSerializer to produce its serialization for the attribute.  So that means, say if you have a notification model that has one todo, you can something like:

```ruby
class Notification < Muesli::Serializers::Base
  @whitelisted_attributes = [
    :created_at,
    :read_at,
    :todo,
    :task
  ]
end
```

... and it'll just work. Neat!
