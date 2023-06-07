# README

Приложение доступно по адресу [http://64.226.86.240/](http://64.226.86.240/experiments)

## API
### Получение списка экспериментов для приложения

Обязательным является заголовок `Device-Token`.

**Request**
```
GET /experiments

Headers:
Device-Token {{device-token}}
```

В ответ возвращается список экспериментов, ассоциированных с устройством.

**Response**
```
{
    "device_id": "{{device-id}}",
    "assigned_experiments": [
        {
            "experiment_name": "button_color",
            "experiment_option": "#FF0000"
        },
        {
            "experiment_name": "price",
            "experiment_option": "50"
        }
    ]
}
```

### Статистика

Эндпоинт для удобства проверки распределения экспериментов между устройствами

**Request**

```
GET /admin/statistics
```

**Response**

```
{
    "button_color | #0000FF": 200,
    "button_color | #00FF00": 200,
    "button_color | #FF0000": 200,
    "price | 10": 450,
    "price | 20": 60,
    "price | 50": 30
    "price | 5": 60,
}
```

Возвращает статистику количества экспериментов. Где ключом является название эксперимента, а значением - количество устройств, с которыми ассоциирован этот эксперимент

## Добавление новых экспериментов

Для удобства конфигурации экспериментов, все они хранятся в YAML-файле. При таком подходе, чтобы добавить новый эксперимент, достаточно описать его в конфигурационном файле. Также возможно иметь разный набор экспериментов для каждого окружения.

```
development:
  button_color:
    "#FF0000": 33.33
    "#00FF00": 33.33
    "#0000FF": 33.33
  price:
    "10": 75
    "20": 10
    "50": 5
    "5": 10

production:
  button_color:
    "#FF0000": 50
    "#00FF00": 50
```

## Хранение данных
Устройства и эскперименты хранятся в БД, в таблицах `devices` и `assigned_experiments` соответственно и имеющих следующую структуру:

![devices](https://i.ibb.co/sgpHCLB/Screen-Shot-2023-06-07-at-23-42-03.png)

![assigned_experiments](https://i.ibb.co/ZWfRM52/Screen-Shot-2023-06-07-at-23-44-39.png)

Промежуточные результаты вычислений хранятся в базе данных redis, в следующем виде

![redis](https://i.ibb.co/sW50T2y/image.png)


## Запуск приложения

Приложение возможно запустить с помощью докера
```
docker-compose -f docker-compose.dev.yml up
```

## Style Guide
Код в приложении следует гайдлайнам [Ruby Style Guide](https://rubystyle.guide/)