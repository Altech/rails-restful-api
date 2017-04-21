# Rails 5 で作る RESTful API 速習会

## 速習メニュー

### GET companies/:id (companies#show)

* 次のフィールドを指定可能に : `id`, `name`, `url`, `origin`, `why_description`, `what_description`, `how_description`, `domain`
* 次のアソシエーションを指定可能に : `avatar`
  * このアソシエーションで指定可能なフィールド : `url`, `width`, `height`

### GET companies (companies#index)

* まずは全会社が変えるようにする
* ページネーションできるように
* Preloader を使って avatar を include したときに N + 1 が起こらないようにする
  * Preloader の追加 : `git merge origin/preloader`
* 国の絞り込みを追加する
* adhoc 引数をメソッドの引数として明示する
  * Acton Args の追加 : `git merge origin/action-args`

### GET companies/:id/employees (companies#employees)

Let's try!

---

# API v2 - protocol and implementation

## API Protocol

### v1 との違い

一番大きなところでは、以下のように設計の考え方が異なる。

- v1 : 1 screen, 1 API call. 画面に必要なものを全て返すエンドポイントを作っていく設計。
- v2 : リソースごとにエンドポイントを作っていく設計（RESTful API）。

RESTful に API を作っていくことの大きなメリットは、アプリの画面と API の結合性が低くなり、生産性が上がること。
具体的には、Web エンジニアがアプリの画面の詳細まで知らなくても設計ができる、iOS と Android で実装状況が異なる場合にも API の中で条件分岐が必要ない、といったことが挙げられる。

これは別の見方をすると、あるエンドポイントが様々な画面で使われるということになる。
画面によって必要な情報の多寡は異なるので、スケールするように、v2 ではデフォルトではリソースの id のみを返し、それ以外の情報は全てホワイトリストで取得する。

### レスポンス形式

v1 と異なり、`{ "data": { ... }}` と言った `data` によるラッピングは行わない。
これは、HTTP ではヘッダーが用意されており、メタデータはここに入れることができるため。

#### 詳細エンドポイントの例

オブジェクトが返る。

```json
# GET /api/v2/users/1
{ "id": 1 }
```

#### 一覧エンドポイントの例

オブジェクトの配列が返る。

```rb
# GET /api/v2/users
[{ "id": 1 }, { "id": 2 }, ...]
```

#### エラー

HTTPステータスは通常の使い方に従う。
より詳細なエラー情報として、`message` と `error_code` をボディに含める。

```rb
{ message: "...", error_code: 100 }
```

### クエリパラメータ

#### フィールドの取得 : `fields`

例えば、ユーザー情報を取得する場合、`fields=name` のように指定すると id に加えて名前が返る。

複数指定する場合、カンマ区切りで `fileds=name,facebook_uid` とするか、角括弧を使って `fields[]=name&fields[]=facebook_uid` とすることで可能。

#### アソシエーションの取得 : `include`

例えば、ユーザーの画像のURLを一緒に取得する場合、`include=avatar&fields=avatar.url` のように指定するとアバターのURLも同時に取得できる。この場合、avatar アソシエーションのフィールド url を `avatar.url` といった形で取得している。

##### ネストしたアソシエーション

例えば会社の社員インタビュー一覧のエンドポイント `GET /companies/:id/employee_interviews` があって、そこでインタビュータイトルと同時にユーザーの名前とアバターURLを取得したい場合、パラメータは、次のようになる。

```
include=user,user.avatar&fields=title,user.name,user.avatar.url
```

#### デバッグパラメータ

事前にどんなパラメータがあるのかこのままでは仕様書が無い限り分からないので、`debug` パラメータを用意してある。これを `true` / `t` に設定すると、全フィールドと一段階までのアソシエーションが全て返る。production 環境では利用できないので注意。

#### ソート

ソートはデフォルトで一覧エンドポイントのテーブルのカラムに対して行えるようになっている。
例えば、`col1`, `col2` というカラムを持つテーブルであれば、`+col1`, `-col1`, `+col2`, `-col2` をデフォルトで受け付ける。

具体例として、ユーザーを名前を昇順で取得したい場合、`sort=+name_ja` といった形で指定できる。ユーザーを facebook_uid の降順で取得したい場合、`sort=-facebook_uid` といった形で指定できる。カンマで区切ることで複数のカラムでのソートも可能。

controller 側で `sort_param` を使うことで、対象テーブルのカラム以外でのソートを定義することも可能。
例えば、 [`companies#employees`](https://github.com/wantedly/wantedly/blob/master/app/controllers/api/v2/companies_controller.rb) では `sort=-score` によって Wantedly スコアの降順でのソートを提供している。大きく、昇順なのか降順なのかは常にあるので、`+` か `-` を先頭につけておくのがベター。

#### ページング

一覧エンドポイントで `per_page` , `page` パラメータを指定することでページングができる。
デフォルトで以下の情報がレスポンスヘッダーに入る。

```
X-List-CurrentPage: 4
```

また、`page_count` パラメータを true に設定することで、次の情報も返る。
バックエンドでは COUNT クエリが余分に一個走るため、デフォルトの挙動にはなっていない。

```
X-List-TotalCount: 123
X-List-NumPages: 1
X-List-IsFisrtPage: true
X-List-IsLastPage: false
```

#### フィルタ

一覧系のエンドポイントでは様々なパラメータでフィルタリングすることが考えられるので、既に挙げたパラメータ以外の任意のパラメータが実装される。
どういう利用可能なパラメータについては、後述するように controller の引数に明示される。

### 関連資料

おおよそ以下の資料に書いてあるような方針で設計している。

* [翻訳: WebAPI 設計のベストプラクティス \- Qiita](http://qiita.com/mserizawa/items/b833e407d89abd21ee72#http-%E3%82%B9%E3%83%86%E3%83%BC%E3%82%BF%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%89%E3%82%92%E6%9C%89%E5%8A%B9%E6%B4%BB%E7%94%A8%E3%81%97%E3%82%88%E3%81%86)
* [綺麗なAPI速習会 \- Qiita](http://qiita.com/shimastripe/items/e9b0e1f8f8d77b89373f)

## API Implementation

基本的には controller と serializer を必須で変更することになる。

### Controller

controller で行う仕事として、以下のものが想定される。

* 詳細の場合は：
  * オブジェクトをDBから取得
* 一覧の場合は追加で：
  * アソシエーションを preload
  * ページネーション
  * ソート
  * フィルタ

#### 詳細の例

```rb
class Api::V2::CompaniesController
  before_action :set_company

  def show
    render json: @company,
      fields: @fields,
      include: @include
  end
end
```

`@fields`, `@include` には、クエリパラメータで指定した値が整形されて入る。これにより、フィールドとアソシエーションの絞り込みが行われる。

#### 一覧の例

```rb
  def posts(categories: Post::COMPANY_FEED_CATEGORIES)
    @posts = @company.posts.listed_in_feed.categorized_as(categories)

    @posts = preload_for(@posts)

    render json: setup_collection(@posts),
      fields: @fields,
      include: @include
  end
```

これは、会社の投稿一覧を取得するエンドポイントの例。`categories` パラメータをフィルタリングのパラメータとして受け取り、`preload_for(@posts)` でアソシエーションの include を行い、`setup_collection(@posts)` でソートとページネーションを行っている。

`preload_for` の仕組みについては後述。

`setup_collection` は `Api::RestfulControllerConcern` に定義されているが、基本的に変更することはない。デフォルトで許可されているのは対象テーブルのカラムのみなので、それ以外のカラム・式でソートできるようにするには `sort_param '-score', order: 'scores.wanted_score DESC, id', joins: :score`  などとする。

### Serializer

JSON の生成には [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers) を利用している。
Rails5 のやり方に従って `app/serializsers` ディレクトリに置く。

例えば、前述の会社詳細であれば、`Company` モデルのシリアライザが必要になるので、`CompanySerializer` を用意する。
この対応付けは規約で行われるので、毎回 serializer を指定する必要はない。

```rb
class CompanySerializer < ApplicationSerializer
  attributes :id, :name, :url # メソッドとして存在するものをそのまま返す場合
  attribute(:employee_count) { object.employees.count } # 何らかの計算が必要になる場合（対象モデルは `object` で参照）

  has_one :avatar # Image のアソシエーションなので ImageSerializer を定義しておく
  has_many :why_images do # ブロックでオブジェクトを直接書くこともできる（モデルにアソシエーションを定義する方が適切な場合も）
    Image.where(imageable: object, name: Company.description_image_names(:why))
  end
end
```

注：このように `has_many` を使っていけば様々な情報を一度に返すことが可能になるが、アソシエーションに対してソートやページネーションをする手段は提供していない。
そういったことを行う場合はエンドポイントとして切り出す方が良いのではないかと思っている。

#### model

あまり多くはないが、ActiveRecord オブジェクト以外を JSON オブジェクトとして返したい場合は、`ActiveModelSerializers::Model` が使える。

```rb
class Models::AttributedString < ActiveModelSerializers::Model
  def initialize(html_string)
    @raw, @strong_positions, @link_positions = parse(html_string)
  end

  attributes :raw, :strong_positions, :link_positions

  def parse(html_string)
    # ...
  end
end
```

これはほぼ通常の属性付きオブジェクトとして扱えるが、`attributes` で定義したフィールドが JSON になり、かつ一部のフィールドのみを取り出すといったことも可能になるため、JSON オブジェクトを返す場合はハッシュではなくこちらを利用する。

#### scope

`scope` によって現在のユーザーを参照でき、可視性の制限などに使える。

```rb
  has_many :comments do
    object.comments.where(created_by: scope)
  end
```

#### 資料

https://github.com/rails-api/active_model_serializers/tree/master/docs に細かく分類されている。
https://github.com/rails-api/active_model_serializers/blob/master/docs/general/serializers.md がシリアライザについてのドキュメントで一番役に立つ。

### Preloader

ActiveModelSerializers は preload の仕組みを提供していないため、追加で prelaod の仕組みを `Api::Preloader` が提供している。

`Api::Preloader` は、リクエストされている attributes や associations に応じて ActiveRecord のアソシエーションの includes を行う `prelaod_for(relation, attributes, associations)` というメソッドを提供していて、これを controller で利用している。

どういうアソシエーションを preload すべきかは、serializer に `preload` ブロックを使って記述する。

```rb
class CompanySerializer < ApplicationSerializer
  ...
  preload do
    attribute :twitter, includes: :links # `twitter` フィールドが使われるときは `links` を preload
    association :avatar # `avatar` アソシエーションが使われるときは `avatar` を preload
  end
end
```

上記アソシエーションの preload の定義は、以下の定義の省略形になる。

```rb
    association :avatar, includes: :avatar, serializer: ImageSerializer
```

従って、以下のようにカスタマイズすることも可能。

```rb
    association :liked_friends, includes: :stargazers # `liked_friends` アソシエーションが使われるときは `stargazers` を preload
    association :why_images, serializer: DescriptionImageSerializer # `why_images` アソシエーションについてどういう preload をすべきかは DescriptionImageSerializer の情報を利用
```

また、以下のケースについては特殊なケースのため機能を提供していない。


* 条件分岐によって preload すべきものが変わる
* 複数の preload が必要
