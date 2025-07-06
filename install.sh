#!/bin/bash

# https://github.com/AdguardTeam/AdGuardHome/wiki/Docker#resolved-daemon
mkdir -p /etc/systemd/resolved.conf.d

sudo tee /etc/systemd/resolved.conf.d/adguardhome.conf > /dev/null <<EOF
[Resolve]
DNS=127.0.0.1
DNSStubListener=no
EOF

mv /etc/resolv.conf /etc/resolv.conf.backup
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

systemctl reload-or-restart systemd-resolved

# Получаем внешний IP-адрес
MYHOST_IP=$(curl -s https://checkip.amazonaws.com/) 

# Записываем IP-адрес в файл docker-compose.yml с меткой MYHOSTIP
sed -i -E  "s/- WG_HOST=.*/- WG_HOST=$MYHOST_IP/g" docker-compose.yml

echo -e "Введите пароль от админки wg-ui (если пропустить, будет задан password): "
read -p "Пароль: " PASSWORD

# Установка пароля по умолчанию, если пользователь пропустил ввод
if [ -z "$PASSWORD" ]; then
  PASSWORD="password"
fi

# Обновление строки PASSWORD в docker-compose.yml
if grep -q "PASSWORD" docker-compose.yml; then
  sed -i -E "s/- PASSWORD=.*/- $PASSWORD/g" docker-compose.yml
  echo "Пароль успешно обновлен в файле docker-compose.yml"
else
  echo "Ошибка: ключ PASSWORD не найден в docker-compose.yml"
  exit 1
fi

echo -e "Введите подсеть в формате 10.10.11.x (если пропустить, будет задана 10.10.11.x): "
read -p "Подсеть: " WG_DEFAULT_ADDRESS

# Установка подсети по умолчанию, если пользователь пропустил ввод
if [ -z "$WG_DEFAULT_ADDRESS" ]; then
  WG_DEFAULT_ADDRESS="10.10.11.x"
fi

# Обновление строки WG_DEFAULT_ADDRESS в docker-compose.yml
if grep -q "WG_DEFAULT_ADDRESS" docker-compose.yml; then
  sed -i -E "s/- WG_DEFAULT_ADDRESS=.*/- $WG_DEFAULT_ADDRESS/g" docker-compose.yml
  echo "Маска подсети успешно обновлена в файле docker-compose.yml"
else
  echo "Ошибка: ключ WG_DEFAULT_ADDRESS не найден в docker-compose.yml"
  exit 1
fi

docker-compose up -d
