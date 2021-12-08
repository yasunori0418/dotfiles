# KeychronキーボードをLiuxに対応させる。

通常Keychronのキーボードはメディアキーが有効になっていて、
ファンクションキーは[fn+]でないと、使えなくなっている。
以下の手順でKeychronキーボードをLinuxに対応させる。


## その1

キーボードのサイドスイッチをWindowsに切り替えて、'Fn+X+L'を押す。


## その2

`/etc/systemd/system/keychron.service`を作る。


## その3

以下のコードを、作ったファイルに書き込む。

```
[Unit]
Description=The command to make the Keychron K2-k4 work with Function keys

[Service]
Type=oneshot
ExecStart=/bin/bash -c "sudo echo 1 | sudo tee /sys/module/hid_apple/parameters/fnmode"
ExecStop=/bin/bash -c "sudo echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode"

[Install]
WantedBy=multi-user.target
```

## その4

コマンドを実行して、systemdに反映する。

```
sudo systemctl enable keychron
```

## おしまい

これで、Keychronキーボードのファンクションキーが有効になる。
メディアキーを使うなら、Fnキーを押しながら、Fキーを押せばいい。
