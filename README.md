# snirin_infra
snirin Infra repository

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
