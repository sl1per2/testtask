# testtask
## Архитектура проекта
<img width="695" height="444" alt="{195E9A30-1156-41D7-94FA-472129196FD7}" src="https://github.com/user-attachments/assets/adecfb5c-7c04-4a00-b5d5-6dacbb26166d" />



## Компоненты

| Контейнер         | IP адрес       | Роль                          |
|-------------------|----------------|-------------------------------|
| lb1               | 172.20.0.10    | MASTER балансировщик          |
| lb2               | 172.20.0.11    | BACKUP балансировщик          |
| backend1          | 172.20.0.20    | Go-приложение ("backend 1")   |
| backend2          | 172.20.0.21    | Go-приложение ("backend 2")   |
| victoriametrics   | 172.20.0.30    | База данных метрик            |
| grafana           | 172.20.0.31    | Визуализация (порт 3000)      |
| ansible           | 172.20.0.40    | Автоматизация                 |

## Технологии

| Технология            | Назначение                          |
|-----------------------|-------------------------------------|
| Keepalived (VRRP)     | Управление VIP                      |
| HAProxy               | Балансировщик                       |
| Go                    | Бекенд                              |
| Victoria Metrics      | БД метрик                           |
| Grafana               | Визуализация и дашборды             |
| Ansible               | Автоматизация                       |
| Docker                | Контейнеризация                     |

## Требования к окружению

 - Docker Engine
 - Docker Compose
 - Git


## Инструкция по запуску 

### 1. Склонировать репозиторий 
git clone https://github.com/sl1per2/testtask

### 2.Собрать и  запустить контейнеры
sudo docker compose -f testtask/docker-compose.yml up -d --build
### 3. Установить и настроить ПО
sudo docker exec ansible ansible-playbook root.yml -i inventory/hosts.ini
### 4. Открыть grafana
http://<ip хоста>:3000/
- Login: admin
- Password: admin

### 5. Сменить пользователя приватного ключа на текущего и дать права на чтение и запись
- sudo chown <пользователь>:<группа> testtask/ansible/keys/*_private
- sudo chmod 600 testtask/ansible/keys/*_private

## Доступ к контейнеру ansible

- sudo docker exec -it ansible /bin/bash
- ssh contuser@172.20.0.40 -i testtask/ansible/keys/contuser_private
- ssh root@172.20.0.40 -i testtask/ansible/keys/root_private


## Скриншоты даш борда
Работает штатно VIP на мастер ноде (lb1)
<img width="1870" height="909" alt="{43D9EF9B-0846-49AC-8340-6FFFA3C8C4BF}" src="https://github.com/user-attachments/assets/30684d9e-d46a-4ad4-90dc-587da6a75b40" />

При отключении значение VIP меняется в таблице Active VIP меняется на lb2, таблица Keepalived Status меняет мастер ноду. 

<img width="1868" height="912" alt="{0ED5F731-E197-494A-B2FA-B5E173BB158D}" src="https://github.com/user-attachments/assets/f5646827-7119-40c7-a88d-3df863c23510" />
