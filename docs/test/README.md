# Тестування працездатності системи

## Зміст

- [Тестування працездатності системи](#тестування-працездатності-системи)
  - [Сценарій для Data](#сценарій-для-data)
  - [Вийнятки для Data](#вийнятки-для-data)

## Сценарій для Data
### GET
Запит на отримання даних

![](./Images/get_get_data.jpg)

Запит на отримання даних за id

![](./Images/get_get_data_2.jpg)

### POST
Запит на додавання даних з усіма заповненими полями

![](./Images/post_post_add_with_all_fields.jpg)

Запит на додавання даних без id, last_edit_date та upload_date

![](./Images/post_post_add_without_some_fileds.jpg)

### PUT
Запит на оновлення id, name, content та category

Перед оновленням

![](./Images/put_get_before_update.jpg)

Після оновлення

![](./Images/put_put_after_update.jpg)

### DELETE
Перевірка даних на існування

![](./Images/delete_get_existence.jpg)

Запит на видалення даних

![](./Images/delete_delete.jpg)

Перевірка видалених даних на існування

![](./Images/delete_get.jpg)

### PATCH
Запит на оновлення name

Перед оновленням

![](./Images/patch_get_before_update.jpg)

Після оновлення

![](./Images/patch_patch_ufter_update.jpg)

## Вийнятки для Data
### GET
Немає даних з певним id

![](./Images/get_exception.jpg)

### POST
Введено не всі обов'язкові дані для заповнення

![](./Images/post_exception.jpg)

### PUT
Введено id, з яким дані вже існують у системі

![](./Images/put_exception.jpg)

### DELETE
Немає даних із заданим id

![](./Images/delete_exception.jpg)

### PATCH
Немає даних із заданим id

![](./Images/patch_exception.jpg)
