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

С помощью команды `docker run` мы запустили на выполнение контейнер hello-world, единственным предназначением которого было выведение на экран текста приветствия. По завершению работы процесса контейнер автоматически прекратил свою работу.

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

Удаление ненужных образов выполняется с помощью команды `rmi`:

```bash
$ docker rmi busybox
Untagged: busybox:latest
Untagged: busybox@sha256:2107a35b58593c58ec5f4e8f2c4a70d195321078aebfadfbfb223a2ff4a4ed21
Deleted: sha256:f6e427c148a766d2d6c117d67359a0aa7d133b5bc05830a7ff6e8b64ff6b1d1d
Deleted: sha256:c5183829c43c4698634093dc38f9bee26d1b931dedeba71dbee984f42fe1270d
```

### Создание контейнера

Для создание контейнера зарегистрируйтесь на [Docker Hub](https://hub.docker.com/). После этого скачайте репозиторий с [тестовым приложением](https://github.com/antonkravtsevich/kubernetes_labs) и перейдите в директорию `flask_base_app`.

Основной файл для создания репозитория называется Dockerfile. Его содержимое выглядит следующим образом:

```Dockerfile
FROM python:3-onbuild

# Порт, который необходимо открыть для внешнего доступа
EXPOSE 5000

# Запускаем приложение на выполнение
CMD ["python", "./app.py"]
```

Секция `FROM` указывает на родительский контейнер. В данном случае это контейнер, содержащий оптимизированный для запуска python-приложений в продакшне. Секция `EXPOSE` устанавливает порт, открытый для внешнего взаимодействия. Секция `CMD` указывает, какие команды необходимо запустить при старте контейнера.

Помимо приложения и файла для сборки контейнера, в папке находится файл `requirements.txt`, который содержит список python-библиотек, необходимых для запуска приложения.

> Название контейнера `antonkravtsevich/base_flask_app` состоит из ID пользователя на Dockerhub (antonkravtsevich) и названия самого контейнера (base_flask_app). Замените ID пользователя своим, чтобы иметь возможность загрузить контейнер на Dockerhub.

Соберем контейнер:

```bash
$ docker build -t antonkravtsevich/base_flask_app .
Sending build context to Docker daemon 4.096 kB
Step 1/3 : FROM python:3-onbuild
# Executing 3 build triggers...
Step 1/1 : COPY requirements.txt /usr/src/app/
Step 1/1 : RUN pip install --no-cache-dir -r requirements.txt
 ---> Running in 75ec8b4fa72a
Collecting Flask==0.12.2 (from -r requirements.txt (line 1))
  Downloading Flask-0.12.2-py2.py3-none-any.whl (83kB)
Collecting itsdangerous>=0.21 (from Flask==0.12.2->-r requirements.txt (line 1))
  Downloading itsdangerous-0.24.tar.gz (46kB)
Collecting Jinja2>=2.4 (from Flask==0.12.2->-r requirements.txt (line 1))
  Downloading Jinja2-2.10-py2.py3-none-any.whl (126kB)
Collecting click>=2.0 (from Flask==0.12.2->-r requirements.txt (line 1))
  Downloading click-6.7-py2.py3-none-any.whl (71kB)
Collecting Werkzeug>=0.7 (from Flask==0.12.2->-r requirements.txt (line 1))
  Downloading Werkzeug-0.14.1-py2.py3-none-any.whl (322kB)
Collecting MarkupSafe>=0.23 (from Jinja2>=2.4->Flask==0.12.2->-r requirements.txt (line 1))
  Downloading MarkupSafe-1.0.tar.gz
Installing collected packages: itsdangerous, MarkupSafe, Jinja2, click, Werkzeug, Flask
  Running setup.py install for itsdangerous: started
    Running setup.py install for itsdangerous: finished with status 'done'
  Running setup.py install for MarkupSafe: started
    Running setup.py install for MarkupSafe: finished with status 'done'
Successfully installed Flask-0.12.2 Jinja2-2.10 MarkupSafe-1.0 Werkzeug-0.14.1 click-6.7 itsdangerous-0.24
Step 1/1 : COPY . /usr/src/app
 ---> 60f8cda970ae
Removing intermediate container ac905ca52934
Removing intermediate container 75ec8b4fa72a
Removing intermediate container 82032170dca7
Step 2/3 : EXPOSE 5000
 ---> Running in 6a3a1ea19281
 ---> 7595e4f26987
Removing intermediate container 6a3a1ea19281
Step 3/3 : CMD python ./app.py
 ---> Running in 66680a2bbaa9
 ---> 147dcd57f85c
Removing intermediate container 66680a2bbaa9
Successfully built 147dcd57f85c

$ docker images
REPOSITORY                        TAG                 IMAGE ID            CREATED             SIZE
antonkravtsevich/base_flask_app   latest              147dcd57f85c        59 seconds ago      697 MB
<none>                            <none>              becb73ed6142        2 minutes ago       688 MB
python                            3-onbuild           badd7f8f9d5a        25 hours ago        688 MB
hello-world                       latest              f2a91732366c        3 months ago        1.85 kB
```

Образ `antonkravtsevich/base_flask_app` появился в списке доступных. Запустим этот контейнер:

```bash
$ docker run -p 8888:5000 antonkravtsevich/base_flask_app
      * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

Флаг -p позволяет указывать проброс портов (в данном случае - с 8888 на 5000). С помощью этой команды можно открыть порты контейнера для доступа извне. Перейдите в браузере по адресу http://127.0.0.1:8888. Если контейнер был запущен успешно, вы получите страницу с текстом `Hello from container!`.

Это все, что необходимо знать для запуска тестового кластера kubernetes.

## Kubernetes