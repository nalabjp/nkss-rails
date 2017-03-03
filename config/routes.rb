Nkss::Engine.routes.draw do
   root :to => 'styleguides#all'
   get ':section' => 'styleguides#show'
end
