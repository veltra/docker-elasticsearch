# Docker Elasticsearch

**注意: このREADMEはClaudeによって自動生成されており、不正確な情報が含まれる可能性があります。**

日本語言語分析プラグインが事前にインストールされたElasticsearch 6.2.4のカスタムDockerイメージです。

## 目次

- [概要](#概要)
- [機能](#機能)
- [アーキテクチャ図](#アーキテクチャ図)
- [環境対応表](#環境対応表)
- [ディレクトリ構成](#ディレクトリ構成)
- [技術スタック](#技術スタック)
- [インストール方法](#インストール方法)
- [使用方法](#使用方法)

## 概要

このリポジトリは、日本語言語分析プラグインが事前にインストールされたElasticsearch 6.2.4のカスタムDockerイメージを含んでいます。このイメージは公式のElasticsearch OSS（オープンソースソフトウェア）ディストリビューションをベースとしており、高度なテキスト処理機能のためのICUとKuromoji分析プラグインが含まれています。

## 機能

- **Elasticsearch 6.2.4**: 公式Elasticsearch OSSディストリビューションをベース
- **日本語言語サポート**: 日本語テキスト分析のためのKuromojiプラグインが事前インストール
- **ICU分析**: 高度なテキスト処理のための国際化コンポーネント（Unicode）プラグイン
- **Docker統合**: Dockerによる簡単なデプロイとテスト
- **自動テスト**: CircleCIによるビルドとテスト自動化のCI/CDパイプライン
- **シングルノード設定**: 開発とテスト環境に最適化

## アーキテクチャ図

TODO: アーキテクチャ図は時間がある際に作成予定です。自動生成できないため手動で作成する必要があります。

## 環境対応表

TODO: 環境対応表は時間がある際に作成予定です。自動生成できないため手動で作成する必要があります。

## ディレクトリ構成

```
docker-elasticsearch/
├── .circleci/                    # CircleCI設定
├── .git/                         # Gitリポジトリ
├── Dockerfile                    # Dockerイメージ定義
├── Makefile                      # ビルドとテスト自動化
├── README.md                     # プロジェクトドキュメント
├── README-ja.md                  # 日本語ドキュメント
├── README-prompot-for-generate.txt # README生成プロンプト
└── .gitignore                    # Git除外ルール
```

## 技術スタック

- **Elasticsearch**: 6.2.4（オープンソースソフトウェア版）
- **Docker**: コンテナ化プラットフォーム
- **CircleCI**: 継続的インテグレーション/継続的デプロイメント
- **Make**: ビルド自動化ツール
- **ICU分析プラグイン**: 国際化コンポーネント（Unicode）
- **Kuromojiプラグイン**: 日本語形態素解析器

## インストール方法

### 前提条件

- システムにDockerがインストールされていること
- Makeユーティリティ（Makefileコマンドを使用する場合、オプション）

### イメージのビルド

```bash
# リポジトリをクローン
git clone <repository-url>
cd docker-elasticsearch

# Dockerイメージをビルド
make build
```

または手動でビルド:

```bash
docker build -t veltra/elasticsearch .
```

## 使用方法

### Elasticsearchコンテナの実行

```bash
# シングルノードディスカバリーでコンテナを実行
docker run -p 9200:9200 -e "discovery.type=single-node" -d --name elasticsearch veltra/elasticsearch
```

### インストールのテスト

```bash
# テストスイートを実行
make test
```

これにより以下が実行されます:
1. Dockerイメージのビルド
2. Elasticsearchコンテナの起動
3. サービスの準備完了を待機
4. curlを使用した接続テスト

### APIエンドポイント

Elasticsearchインスタンスは `http://localhost:9200` で利用可能で、以下のAPIグループがあります:

| エンドポイント      | メソッド | 説明                                   |
| ------------------- | -------- | -------------------------------------- |
| `/`                 | GET      | クラスター情報                         |
| `/_cluster/health`  | GET      | クラスターの健全性ステータス           |
| `/_nodes`           | GET      | ノード情報                             |
| `/_cat/indices`     | GET      | 全インデックスの一覧                   |
| `/{index}/_search`  | POST     | ドキュメントの検索                     |
| `/{index}/_analyze` | POST     | 日本語プラグインを使用したテキスト分析 |

### 環境変数

以下の環境変数を設定できます:

| 変数                     | デフォルト    | 説明                                     |
| ------------------------ | ------------- | ---------------------------------------- |
| `discovery.type`         | `single-node` | シングルノード設定のディスカバリータイプ |
| `ELASTICSEARCH_USERNAME` | -             | 認証用ユーザー名                         |
| `ELASTICSEARCH_PASSWORD` | -             | 認証用パスワード                         |

### 日本語テキスト分析の使用例

```bash
# 日本語テキスト分析のテスト
curl -X POST "localhost:9200/_analyze" \
  -H "Content-Type: application/json" \
  -d '{
    "analyzer": "kuromoji",
    "text": "東京都に住んでいます"
  }'
``` 
