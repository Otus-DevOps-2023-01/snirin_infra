# snirin_infra
snirin Infra repository

ДЗ 13 ansible-4
Сделано:
-Написан тест на доступность порта 27017 у mongo
-Добавлены роли в плейбуки для packer
-В Vagrantfile добавлена переменная `nginx_sites` для проксирования на 80 порт
```
 "nginx_sites" => {"default" => ['listen 80', 'server_name "reddit"', 'location / { proxy_pass http://127.0.0.1:9292; }']}
```
-Роль db Вынесена во внешний репозиторий https://github.com/snirin/otus_devops_ansible_db_role и добавлена обратно
 через requirements.yml

В процессе:
-Увеличена память для команды "bundle install" до 2048, до этого падала с ошибкой
-Уменьшена версия molecule с 5.1.0 до 5.0.1, для борьбы с ошибкой `No module named 'ansible.module_utils.common.yaml'`
по совету из https://github.innominds.com/ansible-community/molecule/issues/3945#issuecomment-1608061119
-`molecule init` запускалась без флага `--scenario-name`, с ним была ошибка `No such option: --scenario-name`

Для себя
Список команд
```
vagrant -v
vagrant init
vagrant up
vagrant up --provider=virtualbox
vagrant box list
vagrant status
vagrant ssh appserver
vagrant provision dbserver
vagrant destroy -f

molecule init
molecule create
molecule list
molecule login -h instance
molecule converge
molecule verify
molecule destroy
molecule test
molecule -vvv test

ansible-lint db.yml

pip3 list | grep molecule

source ~/education/otus-devops/tutorial-env/bin/activate
```

ДЗ 12 ansible-3
Сделано:
-Добавлен nginx в app.yml, приложение по 80 порту доступно
-Настроен динамический инвентори, запуск командой `ansible-playbook -i environments/stage/inventory.sh playbooks/site.yml`

Для себя
https://galaxy.ansible.com/docs/
Список команд
```
ansible-galaxy -h
ansible-vault encrypt environments/stage/credentials.yml
ansible-vault decrypt environments/stage/credentials.yml
ansible-vault edit environments/stage/credentials.yml
```


ДЗ 11 ansible-2
Сделано:
-Переведены провижионеры packer на ansible
-Дополнительно добавлена в плейбук `deploy.yml` установка git
-В output терраформа добавлена переменная `db_internal_ip`, выведена в `inventory.sh`
 и передана через `hostvars[inventory_hostname]['db']['internal_ip']` в `app.yml`
-Загружен yc_compute.py, сделал файл `yc.yml`, поправлен ansible.cfg. Команда `ansible-inventory --list` отработала

С версией ansible 2.15 плагин не работал, установил 2.10

Для борьбы с ошибкой подключения ansible через packer
```
Failed to connect to the host via ssh: Unable to negotiate with 127.0.0.1 port 45547: no matching host key type
found. Their offer: ssh-rsa
```
добавил в ~/.ssh/config строки
```
PubkeyAcceptedAlgorithms +ssh-rsa
HostkeyAlgorithms +ssh-rsa
```
по совету из https://www.bojankomazec.com/2022/10/how-to-fix-ansible-error-failed-to.html


Для себя список команд
```
ansible-playbook reddit_app.yml --limit db --tags db-tag
ansible-playbook reddit_app.yml --limit app --tags app-tag
ansible-playbook reddit_app.yml --limit app --tags deploy-tag --check
ansible-playbook reddit_app.yml --limit app --tags deploy-tag
ansible-playbook site.yml

ansible-doc -t inventory yc_compute
```

Полезное
- block, rescue, always
- ansible_facts и hostvars - https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html
В лекции показано:
- настройка nginx
- block
- when
- get_url
- apt_repository
- шаблоны
- Роли
- теги
- tag never

ДЗ 10 ansible-1
Сделано:
- Написан плейбук для установки reddit, если его еще нет, то результат - "changed=1", если есть - "changed=0"
- Написан скрипт для динамического инвентори `inventory.sh`, для выполнения в `ansible.cfg` добавлены строки
```
  [inventory]
  "enable_plugins = script"
```

Для себя список команд
```
ansible 127.0.0.1 -m ping
ansible 127.0.0.1 -m setup
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

ansible-inventory --list
ansible all -m debug -a "var=hostvars[inventory_hostname]"
```

Полезное
- Опция Gather_facts=false
- Mодуль debug, выводящий результат зарегистрированный ранее. Например, статус nginx в лекции на 1.49.00
- Для модуля shell есть опция changed_when
- Установка mongo с подключением репозиториев https://gist.github.com/Nklya/bb2ca080692f75ef1cb2dd24a9926fa8

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

Для себя список команд
```
terraform/stage$ terraform destroy -auto-approve; terraform apply -auto-approve
```

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
Команды
```
nmap -p 9292 10.10.10.20
nmap  -p0-65535 10.10.10.20 -T5

cd ~/education/otus-devops/snirin_infra/terraform/stage; terraform destroy -auto-approve; terraform apply -auto-approve; cd ~/education/otus-devops/snirin_infra/ansible; ansible-playbook -i environments/stage/inventory.sh playbooks/site.yml --extra-vars "deploy_user=ubuntu"
```

Подключение через openvpn из snirin_infra/cloud-bastion
sudo openvpn --config cloud-bastion.ovpn --auth-user-pass cloud-bastion-password
ssh -i ~/.ssh/appuser appuser@10.128.0.14

Подключение к mongo у pritunl на bastion
mongosh mongodb://127.0.0.1:27017/pritunl?authSource=admin

Подключение по ssh без вопроса про неизвестный хост
ssh yc-user@158.160.109.146 -oStrictHostKeyChecking=no

packer
Подключение в режиме отладки к машине, используемую packer для подготовки образа
packer build -debug
ssh ubuntu@84.201.133.222 -i yc_yandex.pem -oStrictHostKeyChecking=no (yc_yandex.pem - созданный в текущем каталоге файл с приватным ключом)

Отлючение параллелизма packer
packer build -parallel-builds=1 ./ubuntu16.json
для борьбы с ошибкой "Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend)"
Такой способ не сработал https://blog.opstree.com/2022/07/26/how-to-fix-the-dpkg-lock-file-error-in-packer/


https://github.com/Otus-DevOps-2019-11/snirin_infra/blob/master/README.md
