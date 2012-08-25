require ('./middle_ware_one')

use MiddleWareOne

run lambda { |environment|
  [ 404, { "Content-Type" => "text/plain" }, "Fancy meeting you here!" ]
}

