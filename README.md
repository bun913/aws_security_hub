# AWSのセキュリティ系サービスを全て有効化する

今回はこちらのブログにそって以下サービスをとりあえず全て有効化する

https://dev.classmethod.jp/articles/aws-security-all-in-one-2021/

ただし、Configの全てのルールを全てのリージョンで有効化するものであるためコストは随時確認していく必要がある。

頻繁に更新されるリソースがあり、コストが嵩む場合はルールの適用をしないことも検討する。

- CloudTrail
- GuardDuty
- Config
- SecurityHub

SecurityHubで `High` または `Critical` な状態はSlackチャンネルに投稿されるように設定する。

Slackチャンネルへの通知には `ChatBot` を利用する。

2022.4.7時点で Terraformでは `ChatBot`のリソースを作成できないので、一部ハンズオンがあるので注意。
(Lambda関数を使って代用は可能であるが、将来的には対応するであろうことを見越してあえてChatBotを利用)

