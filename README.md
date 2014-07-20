Muesli
======

Provides serialization of models into hashes with attribute whitelisting and authorization for passing to views or as an API response.

## ToDo Example

### TodoSerializer
```ruby
class TodoSerializer < Muesli::BaseSerializer
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
  irb(main):005:0> todo.serializer.to_hash

  => {:created_at => Tue, 28 June 2014 16:42:40 UTC +00:00, :due_at => Tue, 2 July 2014 16:42:40 UTC +00:00, :completed_at => nil, :task => "Mow the car.", :priority => 2}
```

## Include CanCan Support

```ruby
class ValentineSerializer < Muesli::BaseSerializer
  include Muesli::CanCan

  @whitelisted_attributes = [
    :created_at,
    :codename
  ]

  def to_hash
    serialized_hash = super

    # add private attributes only for the owner
    if user and can? :update, model
      serialized_hash.extend! serialize_attributes([
        :crush_name,
        :favorite_candy
      ])
    end
  end
end
```

### Use
```ruby
  irb(main):004:0> valentine = Valentine.first
  irb(main):005:0> serializer = valentine.serializer
  irb(main):006:0> serializer.to_hash

  => {:created_at => Tue, 10 February 2014 16:42:40 UTC +00:00, :codename => "Whisper Smileface"}

  irb(main):007:0> serializer.for_user(user).to_hash

  => {:created_at => Tue, 10 February 2014 16:42:40 UTC +00:00, :codename => "Whisper Smileface", :crush_name => "Steve Buscemi", :favorite_candy => "Macaroon"}
```
