AoutBreakServeのREADME

# セットアップ
以下ubuntu 12.04の場合

## redisのインストール
```
$ apt-get install redis
$ apt-get install redis-server
```
### redisの起動
```
$ redis-server # localhost:6379で起動する
```

## nginxのインストール
ngx-luaも一緒にインストールする
```
$ echo "deb http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list.d/nginx.list
$ echo "deb-src http://nginx.org/packages/ubuntu/ precise nginx" >> /etc/apt/sources.list.d/nginx.list
$ curl http://nginx.org/keys/nginx_signing.key | sudo apt-key add -

$ apt-get update
$ apt-get install -y git
$ apt-get install -y make
$ apt-get install -y dpkg-dev dh-make
$ apt-get install -y libpcre3-dev libssl-dev zlib1g-dev libgeoip-dev libgd2-noxpm-dev libxml2-dev libxslt-dev libpam-dev libexpat-dev liblua5.1-dev libperl-dev

$ mkdir /usr/local/src && cd /usr/local/src/
$ git clone https://github.com/simpl/ngx_devel_kit.git
$ git clone https://github.com/chaoslawful/lua-nginx-module.git
$ wget http://people.FreeBSD.org/~osa/ngx_http_redis-0.3.5.tar.gz
$ tar xvfz ngx_http_redis-0.3.5.tar.gz

$ mkdir /ngxsrc && cd /ngxsrc
$ apt-get source nginx-full
$ cd /ngxsrc/nginx-1.4.5
$ mv AoutBreakServer/nginx-1.4.5_debian_rules /ngxsrc/nginx-1.4.5/debian/rules
$ dpkg-buildpackage -b
$ cd /ngxsrc
$ dpkg -i nginx_1.4.5-1~precise_amd64.deb
$ mv AoutBreakServer/nginx.conf.sample /etc/nginx/nginx.conf
```

## railsの設定及び起動
環境変数BASE_HOSTにhost名を設定する
```
$ cd AoutBreakServer/webfront
$ bundle install
$ rake db:migrate
$ rake db:seed
$ BASE_HOST=dev.127.0.0.1.xip.io rails s # ローカルの場合xip.ioを使うと便利
```

## ブラウザでアクセスする
以下を行う

* ブラウザでdev.127.0.0.1.xip.io:3000にアクセス
* nameにadmin、passwordにadminでログインする
* dev.127.0.0.1.xip.io3000/users/editにアクセスしてパスワードを変更する
* ホームに戻ってContainer Createを押す
* 出て来たダイアログに情報を入力してCreateする

