ActiveAdmin.register Tag do

  permit_params :name, :arguments, :description, :example
  menu false
  # actions only: %i[show update destroy]
end
