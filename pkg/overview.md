# はじめに

gcc, g++ をインストールするためのパッケージが入っています。
例えば、Dockerfileのデバッグのため、何度もインストールを繰り返すとき、ダウンロードの時間を短縮できます。

# 使い方

Dockerfileに下記のように記述することでインストールできます。
```
COPY --from=kshima/gcc.pkg:ubuntu24 / /
RUN /tmp/install
```
タグ ubuntu24 の部分には、ubuntu16, ubuntu20 などを指定できます。

(https://hub.docker.com/repository/docker/kshima/gcc.pkg/tags "")

次のコマンドを実行することで、GCC のバージョン "GccVersion" と Ubuntu のバージョン "UbuntuVersion" を確認できます。
```
docker inspect kshima/gcc.pkg:ubuntu24
```
