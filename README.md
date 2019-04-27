# README

rails c
User.create(email: 'mauro@gmail.com', password: '123456')

- Create and List Orders
localhost:3000/api/v1/orders

- List the Orders of a Purchase Channel
localhost:3000/api/v1/orders?purchase_channel=Site+BR

- Get the status of an Order
localhost:3000/api/v1/orders/1
localhost:3000/api/v1/search?reference=BR102030
localhost:3000/api/v1/search?client_name=São+Benedito

- Update an Order
localhost:3000/api/v1/orders/1

- Create and List batches
localhost:3000/api/v1/batches

- Get batch details
localhost:3000/api/v1/batches/1