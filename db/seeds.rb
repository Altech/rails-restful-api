# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

company_data = [
  ['Wantedly', Date.new(2014,1,1), 'https://site.wantedly.com', "「シゴトでココロオドル人をふやす」というミッションを掲げ、ビジネスSNSのWantedly（ウォンテッドリー）を展開しています。\r\nWantedlyにはおおきく3つの価値があります。\r\n1. Brand : 自分を表現（ブログ、ポートフォリオ、プロフィール）\r\n2. Discover：企業やサービスを発見（Visit, Tools）\r\n3. Connect：出会った人たちとつながる（Chat, People）\r\nWantedlyは世の中の働くひとたちすべてのインフラとして、様々な機能を日々提供して います。", "私達のミッションは「シゴトでココロオドル人を増やす」こと。\r\n\r\nシゴトだからつまらない、シゴトだから仕方がない。そう思って、我慢して、シゴトで不幸になってしまっている人を一人でも減らしたい。友達、家族、恋人など、世間の目を気にせず、自分の好きなシゴトに全力で取り組める。\r\n\r\nそういった社会を実現したいと思っています。", "Wantedlyは「はたらく人すべてのインフラ」を目指し、\r\n\r\n- シゴトマッチングサービス「Wantedly Visit」\r\n- 名刺管理サービス「Wantedly People」\r\n- ビジネスチャット「Wantedly Chat」\r\n\r\nを展開しています。\r\n\r\nまた、シンガポール支社も立ち上がり、海外展開も本格化しています。\r\n\r\n【参考記事】\r\n\r\n好きを仕事にするために必要な、たったひとつのシンプルなこと　\r\nhttp://logmi.jp/11688\r\n\r\nウォンテッドリーがブ ランドを刷新——高速・10枚同時スキャンの名刺管理アプリ「Wantedly People」も公開\r\nhttp://jp.techcrunch.com/2016/11/11/wantedly-people-raised/\r\n\r\nWantedlyが元Twitter Japan の後藤剛一氏を執行役員として迎え、グローバル展開を強化\r\nhttps://prtimes.jp/main/html/rd/p/000000016.000021198.html\r\n", "- 最短距離の最大インパクト\r\n\r\nビジネスもエンジニアも関係なく「自分で作る」ことが評価されます。\r\n戦略だけを考えるのではなく、自ら仮説検証し、今あるリソースの中から、最善のものを選択することが求められます。\r\n\r\n- 社員の半分がエンジニアとデザイナ\r\n\r\nゴールドマン・サックス、Google、モルガン・スタンレー、DeNAなどから人材が集まっています。\r\nチーム自体は小さくても、個の力の集合で、大きなインパクトを生み出します。\r\n\r\n- 居心地の良い環境\r\n\r\nメンバー間の交流を促進するカフェスペースや、集中するための集中部屋など、長時間いても疲れにくいオフィスです。\r\n", 'JP'],
]

99.times do |i|
  company_data << ["すごい株式会社#{i}", Date.today, "https://example-#{i}.com", "インターネット#{i}", "なぜやったか#{i}", "なにをやっているか#{i}", "どうやってるか#{i}", ['JP', 'SG', 'US'].sample]
end

company_data.each do |name, founded_on, url, origin, why_description, what_description, how_description, country|
  c = Company.new
  c.name = name
  c.founded_on = founded_on
  c.origin = origin
  c.why_description = why_description
  c.what_description = what_description
  c.how_description = how_description
  c.country = country
  c.save!
end

avatar = Company.find_by(name: 'Wantedly').build_avatar
avatar.url = "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/346/original/3d3f0504-9153-4580-b6a8-e6b8c2c0db5e.png?1405721630"
avatar.file_width = 128
avatar.file_height = 128
avatar.save!

Company.where.not(name: 'Wantedly').each_with_index do |c,i|
  avatar = c.build_avatar
  avatar.url = "https://www.wantedly.com/assets/#{i}"
  avatar.file_width = 128
  avatar.file_height = 128
  avatar.save!
end
