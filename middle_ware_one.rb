require 'rack'

# A class meant to demonstrate two things:
#
# 1. There is one and only one instance of each piece of middleware. If you
# modify the value of one of its instance variables, the next request will use
# the modified value. Some middleware, such as Sinatra, avoids this situation
# with the dup.call! pattern (see the comment on the last line of the `call`
# method).
#
# 2. If the input stream is read, then it should* be rewound, so that the next
# piece of middleware in the chain finds that the environment is in a "normal"
# state. Otherwise every piece of rack middleware needs to be paranoid that
# some predecessor middleware may have advanced the filehandle and thus
# defensively call `rewind` on it, which may itself be undesired behavior.
#
# To play with this app, simply execute `unicorn` or `rackup` or some other
# Rack app container in the current directory, then do something like:
#
#   curl -X POST -d 'ponies!' http://localhost:9292/

class MiddleWareOne

  def initialize(app)
    @app = app
  end

  def call(env)
    p "#{self.class}@#{self.object_id}"
    p "input stream: #{env['rack.input'].class}@#{env['rack.input'].object_id}"
    p "input: #{env['rack.input'].read}" # print the body of the request to stdout
    env['rack.input'].rewind # if you comment out this line, the call to r.body.read below will return "" because the input stream filehandle has been advanced to the end of the stream
    r = Rack::Request.new(env)
    p "input stream: #{r.body.class}@#{r.body.object_id}" # r.body points to the same object as env['rack.input']
    p "input: #{r.body.read}"
    call!(env) # if you replace this line with 'dup.call!(env)' the app behavior changes
  end

  def call!(env)
    [ 200, { "Content-Type" => "text/plain" }, [ "#{a_number}\n" ] ]
  end

  def a_number
    @some_list ||= [ "three", "two", "one" ]
    @some_list.shift
  end

end
