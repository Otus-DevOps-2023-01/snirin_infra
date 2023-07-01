# snirin_infra
snirin Infra repository

ДЗ 10 ansible-1
Сделано:
- Написан плейбук для установки reddit, если его еще нет, то результат - "changed=1", если есть - "changed=0"

Для себя список команд
appserver ansible_host=35.195.186.154 ansible_user=appuser ansible_private_key_file=~/.ssh/appuser
ansible appserver -i ./inventory -m ping
ansible dbserver -m command -a uptime
ansible app -m ping
ansible all -m ping -i inventory.yml
ansible app -m command -a 'ruby -v'
ansible app -m shell -a 'ruby -v; bundler -v'
ansible db -m command -a 'systemctl status mongod'
ansible db -m systemd -a name=mongod
ansible db -m service -a name=mongod
ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'
ansible-playbook clone.yml

ДЗ 9 terraform-2
Сделано:
- Удалены лишние файлы, параметризованы модули и все отформатировано через terraform fmt
- Настроено хранение стейт файла в удаленном бекенде
- Проверены работу блокировок при одновременном запуске
    Блокировки не работают
    Чтобы не мешали ошибки, что инстанс reddit-app или reddit-db уже существует, добавлено рандомное число к их названию
    Инстансы стали создаваться в двойном экземпляре
    Сделано блокирование работающим через YDB database по инструкции
    https://cloud.yandex.com/en-ru/docs/tutorials/infrastructure-management/terraform-state-lock
- Добавлены провижионеры и их опциональное отключение
- Mongodb открыто наружу

ДЗ 8 terraform-1
Сделано:
 - Установлен terraform и по инструкции созданы файлы необходимые для развертывания приложения
 - Добавлена переменные для приватного ключа и зоны
 - Файлы отформатированы через terraform fmt
 - Создан example-файл для переменных

ДЗ 7 packer-base
Сделано:
 - Создание базового образа - `packer build -var-file variables.json ubuntu16.json`
 - Создание полного образа - `packer build -var-file ./files/reddit-full-variables.json immutable.json`
 - Скрипт создания ВМ из образа - `create-reddit-vm.sh <INSTANCE_NAME> <IMAGE_ID>`, после выполнения скрипта веб-приложение сразу доступно через браузер


ДЗ 6 cloud-testapp
testapp_IP = 158.160.52.147
testapp_port = 9292

Startup скрипт
yc compute instance create \
 --name reddit-app \
 --hostname reddit-app \
 --memory=4 \
 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
 --metadata serial-port-enable=1 \
 --metadata-from-file user-data=./user-data.yaml


ДЗ 5 cloud-bastion
bastion_IP = 158.160.59.119
someinternalhost_IP = 10.128.0.14

Подключение одной командой (4 варианта):
ssh -t -A appuser@158.160.59.119 ssh 10.128.0.14
ssh -J appuser@158.160.59.119 appuser@10.128.0.14
ssh -o ProxyCommand="ssh -W %h:%p appuser@158.160.59.119" appuser@10.128.0.14
ssh -o "ProxyJump appuser@158.160.59.119" appuser@10.128.0.14

Для подключения через "ssh someinternalhost" надо добавить в файл .ssh/config следующие строки (2 варианта):
1.
Host someinternalhost
    Hostname 10.128.0.14
    User appuser
    ProxyJump appuser@158.160.59.119

2.
Host someinternalhost
    HostName 10.128.0.14
    User appuser
    ProxyCommand ssh -W %h:%p appuser@158.160.59.119

Чтобы добавить сертификат для vpn-сервера нужно на странице "settings" в поле "Lets Encrypt Domain" указать 158-160-59-119.sslip.io
После этого открыть интерфейс pritunl по адресу https://158-160-59-119.sslip.io



Заметки для себя

Подключение через openvpn из snirin_infra/cloud-bastion
sudo openvpn --config cloud-bastion.ovpn --auth-user-pass cloud-bastion-password
ssh -i ~/.ssh/appuser appuser@10.128.0.14

Подключение к mongo у pritunl на bastion
mongosh mongodb://127.0.0.1:27017/pritunl?authSource=admin

Подключение по ssh без вопроса про неизвестный хост
ssh yc-user@158.160.109.146 -oStrictHostKeyChecking=no

packer
Подключение в режиме отладки к машине, используемую packer для подготовки образа
ssh ubuntu@84.201.133.222 -i yc_yandex.pem -oStrictHostKeyChecking=no (yc_yandex.pem - созданный в текущем каталоге файл с приватным ключом)

Отлючение параллелизма packer
packer build -parallel-builds=1 ./ubuntu16.json
для борьбы с ошибкой "Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend)"
Такой способ не сработал https://blog.opstree.com/2022/07/26/how-to-fix-the-dpkg-lock-file-error-in-packer/
