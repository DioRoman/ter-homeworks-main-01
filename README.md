# ter-homeworks-main-01

## Установка Terraform 

apt update
apt install gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update
apt install terraform

![Снимок экрана 2025-05-26 173619](https://github.com/user-attachments/assets/f59db309-689c-42ef-b441-926abba9ac87)

## Задание 1

Перейдите в каталог src. Скачайте все необходимые зависимости, использованные в проекте.

`cd /mnt/c/Users/Dio/Netology/ter-homeworks/01/src`

`terraform init`

Изучите файл .gitignore. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)

`personal.auto.tfvars`

Выполните код проекта. Найдите в state-файле секретное содержимое созданного ресурса random_password, пришлите в качестве ответа конкретный ключ и его значение.

`terraform apply`

Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла main.tf. Выполните команду terraform validate. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.

`terraform validate`

_У resource не было задано уникальное имя. А другое имя было неправильное._

Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды docker ps.

![Снимок экрана 2025-05-26 225417](https://github.com/user-attachments/assets/267679ef-0aea-40a6-8f04-3ca8413c79cb)

Замените имя docker-контейнера в блоке кода на hello_world. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду terraform apply -auto-approve.

terraform apply -auto-approve

Объясните своими словами, в чём может быть опасность применения ключа -auto-approve. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды docker ps.

Опасность в отсутвии проверки перед запуском. Пригодиться может в CI/CD автодоставке.

Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.

terraform destroy

cat terraform.tfstate

Объясните, почему при этом не был удалён docker-образ nginx:latest. Ответ ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ, а затем ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ строчкой из документации terraform провайдера docker. (ищите в классификаторе resource docker_image )

Optional
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.

Задание 2

Создайте в облаке ВМ.

Подключитесь к ВМ по ssh и установите стек docker.

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo docker run hello-world

gpasswd -a dio docker

Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.

mkdir /mnt/c/Users/Dio/Netology/ter-homeworks/01/task2
cd /mnt/c/Users/Dio/Netology/ter-homeworks/01/task2

mcedit /mnt/c/Users/Dio/Netology/ter-homeworks/01/task2/main.tf

Используя terraform и remote docker context, скачайте и запустите на вашей ВМ контейнер mysql:8 на порту 127.0.0.1:3306, передайте ENV-переменные.

docker run --name dio-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=diopass! -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=diopass!  -e MYSQL_ROOT_HOST="%" -d mysql:8

Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(name  = "example_${random_password.random_string.result}" , двойные кавычки и фигурные скобки обязательны!)
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"

Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды env. Запишите ваш финальный код в репозиторий.

docker exec -it mysql /bin/bash

Задание 3*

Установите opentofu(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии

# Download the installer script:
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
# Alternatively: wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh

# Give it execution permissions:
chmod +x install-opentofu.sh

# Please inspect the downloaded script

# Run the installer:
./install-opentofu.sh --install-method deb

# Remove the installer:
rm -f install-opentofu.sh

Попробуйте выполнить тот же код с помощью tofu apply, а не terraform apply.

cd /mnt/c/Users/Dio/Netology/ter-homeworks/01/src

tofu init -upgrade
tofu apply
