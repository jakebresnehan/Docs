# Hydre's flow

> What's hydre ?
> 
> Hydre is the name of our project which contains every service we created.

TODO: Correct mistakes

TODO: Finish the documentation

## Definitions

### User {#User}

An user can be either a client or an anonymous user.

```json
{
    "type": "client",
    "id": "a7591b95-bd26-4580-a194-c0116d743ffb",
    "roles": ["ADMIN"]
}
```

```json
{
    "type": "anonymous",
    "id": "8bcd1262-f6e5-4ae6-bd14-f00a928cda34"
}
```

## Content

Hydre's head are connected to our RabbitMQ.

Each request will result in a `Result`. If neither `correlation_id` nor `reply_to` are defined, the request will not be performed.

### Receive

Each service need to receive a message with the following attachments :

| Field's location & name | Description | Type |
| - | - | :-: |
| `body:executor` | The user who executed the request | [`User`](#User) |
| `body:data` | The needed data (see service required data) | `Object` |
| `message:reply_to` | The channel which receive the response | `String` |
| `message:correlation_id` | The request id | `String` |

If a message doesn't contain `correlation_id` and `reply_to`, no action will be performed.

#### Example

Message's content:

```json
{
    "executor": {
        "type": "anonymous",
        "id": "8bcd1262-f6e5-4ae6-bd14-f00a928cda34"
    },
    "data": {
        "a": 5,
        "b": 10
    }
}
```

### Result

A result can be a `Success` or an `Error`.

#### Success

```json
{
    "executor": {
        "type": "anonymous",
        "id": "8bcd1262-f6e5-4ae6-bd14-f00a928cda34"
    },
    "data": {
        "result": 15
    },
    "type": "Success"
}
```

#### Error

The `error.code` key is in the big book of Islands errors!

```json
{
    "executor": {
        "type": "anonymous",
        "id": "8bcd1262-f6e5-4ae6-bd14-f00a928cda34"
    },
    "error": {
        "code": 42,
        "message": "Calcul too hard!"
    },
    "type": "Error"
}
```
