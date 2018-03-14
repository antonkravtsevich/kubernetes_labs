# Docker, Kubernetes, Minikube, etc

## Установка тестового окружения (Ubuntu 16.04 Xenial)

Перед установкой тестового окружения необходимо проверить, включена ли аппаратная виртуализация (VT-x или AMD-v). Для проверки используйте простой скрипт:

```bash
if [ -z "$(egrep 'vmx|svm' /proc/cpuinfo)" ]; then
  echo "Virtualisation is not enabled"
else
  echo "Virtualization is enabled"
fi
```

Так же необходимо скачать и установить VirtualBox.
Качаем загрузочный файл (другие версии доступны [по cсылке](https://www.virtualbox.org/wiki/Download_Old_Builds)):

```bash
curl -o virtualbox.deb https://download.virtualbox.org/virtualbox/5.1.32/virtualbox-5.1_5.1.32-120294~Ubuntu~xenial_amd64.deb
```

Устанавливаем VirtualBox:

```bash
sudo dpkg -i virtualbox.deb
```

### Установка Docker

Удаляем предыдущие версии:

```bash
sudo apt-get remove docker docker-engine docker.io
```

Скачиваем установочный пакет Docker:

```bash
curl -o docker.deb https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.03.2~ce-0~ubuntu-xenial_amd64.deb
```

> Если вы используете другую версию Ubuntu, перейдите [по ссылке](https://download.docker.com/linux/ubuntu/dists/), выберите вашу версию дистрибутива, перейдите в папку /pool/stable и выберите вашу архитектуру (например, amd64). Скачайте `.deb` файл Docker.

Устанавливаем Docker из загруженного .deb файла, выполнив:

```bash
sudo dpkg -i ./docker.deb
```

(измените путь/название файла при необходимости)

### Установка kubectl

Скачиваем исполняемый файл kubectl:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```

Выдаем права на запуск:

```bash
chmod +x ./kubectl
```

Перемещаем исполняемый файл в стандартную директорию для исполняемых файлов в Ubuntu:

```bash
sudo mv ./kubectl /usr/local/bin/kubectl
```

### Установка minikube

Скачиваем исполняемый файл minikube:

```bash
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v0.25.0/minikube-linux-amd64
```

Выдаем права на запуск:

```bash
chmod +x ./minikube
```

Перемешаем исполняемый файл в стандартную директорию для исполняемых файлов в Ubuntu:

```bash
sudo mv ./minikube /usr/local/bin/minikube
```

Проверим установку minikube:

```bash
$ minikube start
Starting local Kubernetes v1.9.0 cluster...
Starting VM...
Downloading Minikube ISO
 142.22 MB / 142.22 MB [============================================] 100.00% 0s
Getting VM IP address...
Moving files into cluster...
Downloading localkube binary
 162.41 MB / 162.41 MB [============================================] 100.00% 0s
 0 B / 65 B [----------------------------------------------------------]   0.00%
 65 B / 65 B [======================================================] 100.00% 0sSetting up certs...
Connecting to cluster...
Setting up kubeconfig...
Starting cluster components...
Kubectl is now configured to use the cluster.
Loading cached images from config file.
```

Получим информацию о статусе minikube-кластера:

```bash
$ minikube status
minikube: Running
cluster: Running
kubectl: Correctly Configured: pointing to minikube-vm at 192.168.99.100
```

Проверим корректность работы kubectl:

```bash
$ kubectl get nodes
TODO: add `get nodes` output while work with minikube
```

Для вывода информации и управления кластером используется панель управления minikube (minikube dashboard). Запускается она одноименной командой:

```bash
minikube dashboard
```

В случае необходимости, minikube-кластер можно остановить данной командой:

```bash
$ minikube stop
Stopping local Kubernetes cluster...
Machine stopped.
```

## Docker

[Docker](https://www.docker.com/) - это откртая платформа для разработки, доставки и эксплуатации приложений. Docker предоставляет возможность запускать изолированные на уровне системы приложения, причем делать это намного быстрее и проще, чем с помощью виртуальных машин.

Docker состоит из трех компонентов:

1. Образы (images) - read-only шаблон, на основе которого создается контейнер. Бывают базовыми (например, образы операционных систем) и дочерние (образы, построенные на базовых и имеющие дополнительный функционал)

2. Контейнеры - процесс (приложение), изолированный в окружении, содержащим все необходимое для работы этого процесса. Контейнеры могут быть созданы (из образа), запущены, остановлены, перенесены или удалены. Каждый контейнер является безопасной переносимой платформой для приложения. Контейнеры - это основная компонента работы Docker.

3. Реестр (register) - хранилище образов. Бывают публичными и приватными. Позволяют скачивать и загружать образы. Самым большим публичным реестром является [Docker Hub](https://hub.docker.com/)

Docker использует клиент-серверную архитектуру. Клиент предоставляет интерфейс, получает команды от пользователя и передает их демону Docker, который создает, запускает и распределяет контейнеры. Клиент и сервер могут работать в одной системе, либо клиент может подключаться к удаленному серверу, используя RESTfull API или сокеты.

Docker-контейнеры используют так называемую "объединенную файловую систему" (union file sistem), состоящую из нескольких слоев. При этом одинаковые слои не дублируются в памяти хост-машины, а используются совместно (разумеется, с выполнением условия изоляции), что позволяет существенно сократить объемы памяти, необходимые для хранения контейнеров.

Docker следует принципу "один контейнер - один процесс". Это значит, что каждый контейнер должен содержать только один процесс(приложение), взаимодействующий с другими приложениями по сети. Помимо этого, принято считать, что docker-контейнер - это инструмент, и должен использоваться только по необходимости. Это значит, что в docker-контейнере не должны храниться какие-либо данные, являющиеся результатом работы контейнера.

### Основы Docker

Запустим простейший docker-контейнер:

```bash
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

С помощью команды `docker run` мы запустили на выполнение контейнер hello-world, единственным предназначением которого было выведение на экран приветственного текста. По завершению работы процесса контейнер автоматически прекратил свою работу.

Попробуем кое-что более интересное. Для этого скачаем из официального реестра Docker Hub образ [BusyBox](https://ru.wikipedia.org/wiki/BusyBox) - набора утилит для командной строки Linux.

Загрузим образ BusyBox:

```bash
docker pull busybox
```

Получим список загруженных образов:

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
busybox             latest              f6e427c148a7        13 days ago         1.15 MB
hello-world         latest              f2a91732366c        3 months ago        1.85 kB
```

Запустим скрипт на выполнение в контейнере BusyBox:

```bash
$ docker run busybox echo "hello from busybox"
hello from busybox
```

Для вывода информации о запущенных процессов используется команда

```bash
docker ps
```

Для вывода информации о запущенных ранее процессах добавьте ключ `-a`
Так же контейнер можно запускать в интерактивном режиме, используя флаг `-it`.
Запустим на выполнение bash-оболочку в контейнере BusyBox в интерактивном режиме:

```bash
$ docker run -it busybox sh
/ # ls
bin   dev   etc   home  proc  root  sys   tmp   usr   var
/ # whoami
root
```

Для удаления контейнера воспользуемся командой `docker rm` с указанием идентификатора контейнера, например

```bash
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                          PORTS               NAMES
ecfe781b05ec        busybox             "sh"                     2 minutes ago       Exited (0) About a minute ago                       cocky_nobel
5fac160babc1        busybox             "echo 'hello from ..."   11 minutes ago      Exited (0) 11 minutes ago                           dreamy_bardeen
$ docker rm ecfe781b05ec 5fac160babc1
ecfe781b05ec
5fac160babc1
```

Так же можно удалить все контейнеры, воспользовавшись командой `docker rm $(docker ps -a -q -f status=exited)`

Удаление ненужных контейнеров выполняется с помощью команды `rmi`:

```bash
$ docker rmi busybox
Untagged: busybox:latest
Untagged: busybox@sha256:2107a35b58593c58ec5f4e8f2c4a70d195321078aebfadfbfb223a2ff4a4ed21
Deleted: sha256:f6e427c148a766d2d6c117d67359a0aa7d133b5bc05830a7ff6e8b64ff6b1d1d
Deleted: sha256:c5183829c43c4698634093dc38f9bee26d1b931dedeba71dbee984f42fe1270d
```


##########################################################


## Tectonic sandbox:

качаем тута: https://coreos.com/tectonic/sandbox/

распаковываем, переходим в директорию, вбиваемRCC Institute of Technolog

vagrant up --provider=virtualbox

ждем 15-20 минут, пока качаются инсталляционные файлы CoreOS
потом пойдет установка Tectonic, еще минут 20

Когда установка завершится, мы можем открыть доступ к консоли
для этого необходимо перейти по адресу https://console.tectonicsandbox.com/ (т.к. это локальное соединение, то выдаст ошибку "подключение не защищено". Все окей, так и надо.

Имя пользователя в консоли: admin@example.com
пароль: sandbox

Для генерации файла настроек kubectl:
From Tectonic Console, click Tectonic Admin > My Account on the bottom left of the page.
Click KUBECTL: Download Configuration, and follow the onscreen instructions to authenticate.
When the Set Up kubectl window opens, click Verify Identity.
Enter username: admin@example.com and password: sandbox, and click Login.
Copy the alphanumeric string on the Login Successful screen.
Switch back to Tectonic Console, enter the string in the field provided, and click Generate Configuration to open the Download kubectl Configuration window.

Скопируйте загруженный файл kubectl-config в папку ~/.kube, изменив его имя на config
cp ~/Загрузки/kubectl-config ~/.kube/config

Проверьте корректность kubectl, получив список нодов:
$ kubectl get nodes
NAME                     STATUS    ROLES     AGE       VERSION
c1.tectonicsandbox.com   Ready     master    25m       v1.7.5+coreos.1
w1.tectonicsandbox.com   Ready     node      25m       v1.7.5+coreos.1

Остановка кластера tectonic:
из папки tectonic-sandbox выполнить
$ vagrant halt
==> c1: Attempting graceful shutdown of VM...
==> w1: Attempting graceful shutdown of VM...

продолжение тут: https://coreos.com/tectonic/docs/latest/tutorials/sandbox/first-app.html

вот тут короче та же херня, но для реальных машин и кластера на 10 нод

