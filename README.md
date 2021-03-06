# AWSのセキュリティ系サービスを全て有効化する

今回はこちらのブログにそって以下サービスを全て有効化するためのレシピとなる

https://dev.classmethod.jp/articles/aws-security-all-in-one-2021/

- CloudTrail
- GuardDuty
- Config
- SecurityHub

![構成図](infra/docs/images/system_archi.png)

Configの全てのルールを全てのリージョンで有効化するものであるためコストは随時確認していく必要がある。

頻繁に更新されるリソースがあり、コストが嵩む場合はルールの適用をしないことも検討する。

SecurityHubで `High` または `Critical` な状態はSlackチャンネルに投稿されるように設定する。

Slackチャンネルへの通知には `ChatBot` を利用する。

2022.4.7時点で Terraformでは `ChatBot`のリソースを作成できないので、一部ハンズオンがあるので注意。
(Lambda関数を使って代用は可能であるが、将来的には対応するであろうことを見越してあえてChatBotを利用)

## 手順

### Slackチャンネルの準備とWebHookURLの準備

### SecurityHubの設定(手動)

![SecurityHubの有効化](infra/docs/images/securityhub.png)

SecurityHubのサービスに移動して「SecurityHubに移動」を押下します

![SecurityHub2](infra/docs/images/securityhub2.png)

今回は以下のルールのみ有効化します

- AWS 基礎セキュリティのベストプラクティス v1.0.0 を有効化

### Terraformでリソース群を作成

```bash
cd infra/global
terraform init
terraform plan
terraform apply
```

### Chatbotの作成(手動)

こちらのブログ 「3.AWS Chatbotの設定」の手順どおりにChatbotを作成します。

https://blog.serverworks.co.jp/2021/12/27/210000

### 確認

SecurityHubで `Critical` もしくは `High` の問題が新たに検出されれば以下のようにSlackに通知が届きます。

テストする場合は一時的にSecurityGroupを作成し、インバウンドルールでSSH接続をフルオープン(0.0.0.0/0)などに設定すれば検出してくれます。
**もちろん作ったSGはテストの後に削除しましょう**

![Slack通知](infra/docs/images/slack.png)

すでに `Critical` または `Higt` のルールが検出されている場合は、「ワークフローのステータス」を「新規」に設定することでSlackに通知が届きます。

![新規に変更](infra/docs/images/securityhub-changed.png)