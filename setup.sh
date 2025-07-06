apt update
apt install -y docker.io docker-compose git sudo
systemctl enable --now docker

# создание папки adwireguard-installer
if [ ! -d "adwireguard-installer" ]; then
  mkdir adwireguard-installer
  echo "Папка adwireguard-installer создана."
else
  echo "Папка adwireguard-installer уже существует."
fi

# Клонирование репозитория
echo -e "Клонирование репозитория adwireguard-installer..."
git clone https://github.com/VlaVer98/adwireguard-installer.git adwireguard-installer

echo -e "Репозиторий adwireguard-installer успешно клонирован до актуальной версии в репозитории."

# Переходим в папку adwireguard-installer
echo -e "Переходим в папку adwireguard-installer..."
cd adwireguard-installer
echo -e "Перешли в папку adwireguard-installer"

# Установка прав на файл установки
echo -e "Установка прав на файл установки..."
chmod +x install.sh
echo -e "Права на файл установки выставлены."

# Запуск установки
echo -e "Запуск установки adwireguard..."
./install.sh
echo -e "Установка adwireguard успешно завершена."
