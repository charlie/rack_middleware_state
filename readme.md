# Basics of Rack middleware state

Sometimes I hear people saying things like "New middleware objects are created
for each request!" No, they're not.

This is meant to demonstrate two simple things about how middleware can
permanently modify the state of the application simply by using instance
variables, and also that there is one and only one input stream, and therefore
it needs to be handled with care.
