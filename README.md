# ter-homeworks-main-01

## Установка Terraform 

```
apt update
apt install gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt update
apt install terraform
```

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

https://github.com/DioRoman/ter-homeworks-main-01/blob/main/main.tf

Замените имя docker-контейнера в блоке кода на hello_world. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду terraform apply -auto-approve.

`terraform apply -auto-approve`

Объясните своими словами, в чём может быть опасность применения ключа -auto-approve. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды docker ps.

_Опасность в отсутвии проверки перед запуском. Пригодиться может в CI/CD автодоставке._

Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.

`terraform destroy`

`cat terraform.tfstate`

![Снимок экрана 2025-05-26 233926](https://github.com/user-attachments/assets/57429ac0-27c5-4cdb-819f-f59e407acab5)

Объясните, почему при этом не был удалён docker-образ nginx:latest. Ответ ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ, а затем ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ строчкой из документации terraform провайдера docker. (ищите в классификаторе resource docker_image )

_Optional
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation._

Задание 2

Создайте в облаке ВМ.

![Снимок экрана 2025-05-28 234453](https://github.com/user-attachments/assets/e4956a2d-1c4b-4261-8efa-e3cda101769b)

Подключитесь к ВМ по ssh и установите стек docker.

```
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
`sudo apt-get update`

`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y`

`sudo docker run hello-world`

`gpasswd -a dio docker`

Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
Используя terraform и remote docker context, скачайте и запустите на вашей ВМ контейнер mysql:8 на порту 127.0.0.1:3306, передайте ENV-переменные.
Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(name  = "example_${random_password.random_string.result}" , двойные кавычки и фигурные скобки обязательны!)
Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды env. Запишите ваш финальный код в репозиторий.

`docker exec -it mysql /bin/bash`

https://github.com/DioRoman/ter-homeworks-main-01/blob/main/main.tf

![Снимок экрана 2025-05-28 232723](https://github.com/user-attachments/assets/6c869c86-d373-49c7-9286-f3f207775bf0)

![Снимок экрана 2025-05-28 232804](https://github.com/user-attachments/assets/4144a993-e346-4c28-a98d-e7f5442d2d27)

Задание 3*

Установите opentofu(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии

`curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh`

`chmod +x install-opentofu.sh`

`./install-opentofu.sh --install-method deb`

`rm -f install-opentofu.sh`

Попробуйте выполнить тот же код с помощью tofu apply, а не terraform apply.

`cd /mnt/c/Users/Dio/Netology/ter-homeworks/01/src`

`tofu init -upgrade`

`tofu apply`


