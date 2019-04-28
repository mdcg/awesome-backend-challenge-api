# AutoForce - Backend Challenge

[![GitHub](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/mdcg/awesome-backend-challenge-ruby-api/blob/master/LICENSE)

:rocket: An awesome RESTful API to an awesome backend challenge


## Introduction

First of all, I would like to thank autorforce for the opportunity to show some of my work, then THANK YOU SO MUCH! Next I will talk about the technologies I have chosen for this project, as well as some architectural decisions.

## Stack

The technologies used in this project are:

- Docker;
- Docker Compose;
- Ruby on Rails;
- PostgreSQL;

Why use Docker? Because, Docker is a tool designed to make it easier to create, deploy, and run applications by using containers. Containers allow a developer to package up an application with all of the parts it needs, such as libraries and other dependencies, and ship it all out as one package. By doing so, thanks to the container, the developer can rest assured that the application will run on any other Linux machine regardless of any customized settings that machine might have that could differ from the machine used for writing and testing the code.

The entire application is already configured to run in the Docker container. For that reason, I suggest you have Docker and Docker Compose installed on your machine.

To install them, just click on the links below:

- [Install Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [Install Docker Compose](https://docs.docker.com/compose/install/)

## Architectural Decisions

I will now clarify some of the architectural decisions I have made.

### Permission layer

Initially, I chose to create a permission layer to ensure that each user has access only to orders and batches related to him. Therefore, the only route that does not require authentication headers is the user registration route.

### JSON Responses

[JSend](https://github.com/omniti-labs/jsend) is a specification that lays down some rules for how JSON responses from web servers should be formatted. JSend focuses on application-level (as opposed to protocol- or transport-level) messaging which makes it ideal for use in REST-style applications and APIs. There are lots of web services out there providing JSON data, and each has its own way of formatting responses. Also, developers writing for JavaScript? front-ends continually re-invent the wheel on communicating data from their servers. While there are many common patterns for structuring this data, there is no consistency in things like naming or types of responses. Also, this helps promote happiness and unity between backend developers and frontend designers, as everyone can come to expect a common approach to interacting with one another.

You can read more about this pattern by clicking [here](https://github.com/omniti-labs/jsend).

## First steps

Now that I have explained the architectural decisions of the project a bit, let's work!

First of all, make sure you have installed [Docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/) on your machine.

In the project root folder, where the `Dockerfile` and `docker-compose.yml` files are located, run the following command:

```shell
$ docker-compose up
```

*PS: Keep in mind that for many Docker and Docker Compose commands, you need to give 'sudo' privileges. If the above command does not work, add 'sudo' and try again.*

It should take a while for the container build, so have a little patience. If everything goes well, you'll see a response on your terminal much like this:

```shell
Starting awesome-backend-challenge-ruby-api_db_1 ... done
Starting awesome-backend-challenge-ruby-api_web_1 ... done
Attaching to awesome-backend-challenge-ruby-api_db_1, awesome-backend-challenge-ruby-api_web_1
db_1   | 2019-04-28 04:15:59.968 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
db_1   | 2019-04-28 04:15:59.968 UTC [1] LOG:  listening on IPv6 address "::", port 5432
db_1   | 2019-04-28 04:15:59.985 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
db_1   | 2019-04-28 04:16:00.029 UTC [23] LOG:  database system was shut down at 2019-04-28 04:15:53 UTC
db_1   | 2019-04-28 04:16:00.051 UTC [1] LOG:  database system is ready to accept connections
web_1  | => Booting Puma
web_1  | => Rails 5.2.3 application starting in development 
web_1  | => Run `rails server -h` for more startup options
web_1  | Puma starting in single mode...
web_1  | * Version 3.12.1 (ruby 2.5.5-p157), codename: Llamas in Pajamas
web_1  | * Min threads: 5, max threads: 5
web_1  | * Environment: development
web_1  | * Listening on tcp://0.0.0.0:3000
web_1  | Use Ctrl-C to stop
```

Now that we have everything configured and our server is running, we can finally test our application.

## Entities

The entities as well as their properties follow as specified in the 'AutoForce - Backend Challenge', except for:

- A new entity called `User`. This way, we add a permission layer and also ensure that each user is only working with their stuff;
- By default, when created, the Orders have the status of `ready`;
- To facilitate the *financial report*, the `total_value` property of an Order is of the decimal type.

## Actions

### User Registration

As stated before, all routes need an authentication header. Token authentication support has been removed from Devise for security reasons, so I chose to use (simple_token_authentication)[https://github.com/gonzalo-bulnes/simple_token_authentication]. To get access to your authentication token just make a request below:

```shell
curl --location --request POST "localhost:3000/api/v1/signup" \
  --form "email=mauro@ruby.com" \
  --form "password=123456" \
  --form "name=Mauro"
```

*PS: Name is not required, however email and password are.*

If all goes well, you'll get a response like the one below:

```javascript
{
    "status": "success",
    "data": {
        "user": {
            "id": 1,
            "email": "mauro@ruby.com",
            "created_at": "2019-04-28T04:51:59.492Z",
            "updated_at": "2019-04-28T04:51:59.492Z",
            "name": "Mauro",
            "authentication_token": "9A2zUyWaTRx5kG5LozRJ"
        }
    }
}
```

If you try to register an email that has already been registered in the system, the image below will be displayed:

```javascript
{
    "status": "fail",
    "data": {
        "email": "E-mail already registered"
    }
}
```

Similarly, if you do not send the email or password in the request body, the response will be as follows:

```javascript
{
    "status": "fail",
    "data": {
        "email": "Please enter an email",
        "password": "Please enter a password"
    }
}
```

### Create a new Order

To create an order, simply pass the e-mail and the token in the request header, along with the request body, as in the example below:

```shell
curl --location --request POST "localhost:3000/api/v1/orders" \
  --header "X-User-Email: mauro@ruby.com" \
  --header "X-User-Token: 9A2zUyWaTRx5kG5LozRJ" \
  --header "Accept: application/json" \
  --form "reference=BR10203" \
  --form "purchase_channel=Site BR" \
  --form "client_name=São Benedito" \
  --form "address=Av. Amintas Barros Nº 3700 - Torre Business, Sala 702 - Lagoa Nova CEP: 59075-250" \
  --form "delivery_service=SEDEX" \
  --form "total_value=123" \
  --form "line_items={sku: powebank-sunshine, capacity: 10000mah}"
```


If all goes well, you'll get a response like the one below:

```javascript
{
    "status": "success",
    "data": {
        "order": {
            "id": 1,
            "reference": "BR10203",
            "purchase_channel": "Site BR",
            "client_name": "São Benedito",
            "address": "Av. Amintas Barros Nº 3700 - Torre Business, Sala 702 - Lagoa Nova CEP: 59075-250",
            "delivery_service": "SEDEX",
            "total_value": "123.0",
            "line_items": "{sku: powebank-sunshine, capacity: 10000mah}",
            "status": "ready",
            "user_id": 1,
            "batch_id": null,
            "created_at": "2019-04-28T04:58:13.883Z",
            "updated_at": "2019-04-28T04:58:13.883Z"
        }
    }
}
```

If you do not fill in the authentication header correctly (it fits all routes):

```javascript
{
    "error": "You need to sign in or sign up before continuing."
}
```

In case the request data is not informed:
```javascript
{
    "status": "fail",
    "data": {
        "reference": [
            "can't be blank"
        ],
        "purchase_channel": [
            "can't be blank"
        ],
        "client_name": [
            "can't be blank"
        ],
        "address": [
            "can't be blank"
        ],
        "delivery_service": [
            "can't be blank"
        ],
        "total_value": [
            "can't be blank"
        ],
        "line_items": [
            "can't be blank"
        ]
    }
}
```

### Get the status of an Order

There are three routes created especially for this action. The first one is if you are doing an ID search as the REST pattern, you can send a request like the one below:

```shell
curl --location --request GET "localhost:3000/api/v1/orders/1" \
  --header "X-User-Email: mauro@ruby.com" \
  --header "X-User-Token: tVGzvKBvEhUDPz-tSqyX" \
  --header "Accept: application/json"
```

The second is by reference, you can do the query by sending a request like the one below:

```shell
curl --location --request GET "localhost:3000/api/v1/search?reference=BR10203" \
  --header "X-User-Email: mauro@ruby.com" \
  --header "X-User-Token: tVGzvKBvEhUDPz-tSqyX" \
  --header "Accept: application/json"
```

And the last one is by client name, you can search as follows:

```shell
curl --location --request GET "localhost:3000/api/v1/search?client_name=S%C3%A3o+Benedito" \
  --header "X-User-Email: mauro@ruby1.com" \
  --header "X-User-Token: tVGzvKBvEhUDPz-tSqyX" \
  --header "Accept: application/json"
```

With the exception of the first route, the last two can bring more than one order, since our long-time recurring clients, they may have many Orders in our platform.

if any order is found, here's the answer:

```javascript
{
    "status": "success",
    "data": {
        "orders": [
            {
                "id": 1,
                "reference": "BR10203",
                "purchase_channel": "Site BR",
                "client_name": "São Benedito",
                "address": "Av. Amintas Barros Nº 3700 - Torre Business, Sala 702 - Lagoa Nova CEP: 59075-250",
                "delivery_service": "SEDEX",
                "total_value": "123.0",
                "line_items": "{sku: powebank-sunshine, capacity: 10000mah}",
                "status": "ready",
                "user_id": 2,
                "batch_id": null,
                "created_at": "2019-04-28T04:58:13.883Z",
                "updated_at": "2019-04-28T04:58:13.883Z"
            }
        ]
    }
}
```

If there are none:

```javascript
{
    "status": "success",
    "data": {
        "orders": []
    }
}
```

### List the Orders of a Purchase Channel

### Create a Batch

### Produce a Batch

### Close part of a Batch for a Delivery Service

### A simple financial report

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

- Produce a batch
localhost:3000/api/v1/batches/1/produce

- Submit a batch
localhost:3000/api/v1/batches/1/submit

- Financial Report
localhost:3000/api/v1/report?purchase_channel=