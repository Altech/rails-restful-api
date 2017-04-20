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

users = [
  ["Daisuke Fujita", "藤田 大介", nil, 118],
  [nil, "大墨 \b昂道", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/1595667/original/ca069636-63d0-4fbe-b473-53247e04984e.jpeg?1492440738", 4],
  ["Yoshiki Fujiwara", "藤原 慶貴", nil, 34],
  ["Takao Sumitomo", "住友 孝郎", nil, 137],
  ["Makoto Tanji", "丹治 信", nil, 105],
  ["Kent Nagata", "永田 健人", nil, 60],
  ["Erika Hori", "堀 恵梨佳", nil, 31],
  ["一條 端澄", "一條 端澄", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/1561607/original/7cb1f3d8-e29e-44ac-8322-600b722e4a86.png?1491579947", 36],
  ["Yoshinori Kawasaki", "川崎 禎紀", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/16282/original/a64ff70d-f1fa-41aa-b36e-03b104f9bc6e.jpeg?1460535259", 141],
  ["Yuki Iwanaga", "岩永 勇輝", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/172886/original/d67c0133-6adb-49d7-afcb-c0cc38cf6dec.png?1473561549", 164],
  ["Takuma Seno", "妹尾 卓磨", nil, 63],
  [nil, "小西 遼", nil, 10],
  ["Sohei Takeno", "竹野 創平", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/83346/original/1dbfe173-405a-4637-ac09-108747ba6a50.png?1423848575", 85],
  ["chifumi kamijima", "Kamijima Chifumi", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/238146/original/098f9eca-a70f-4218-9359-0df0950a482b.png?1492404710", 47],
  ["Jiro Nagashima", "永島 次朗", nil, 96],
  ["Rei Kubonaga", "久保長 礼", nil, 124],
  ["Nao Minami", "南 直", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/133790/original/a21ef78b-68fd-4dce-a0c3-c94916bf3019.jpeg?1456597854", 106],
  ["Mamoru Amano", "Mamoru Amano", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/257037/original/0493260a-8c27-48c6-a837-c16540d7aea8.jpeg?1452065853", 96],
  ["Yohei Sugigami", "杉上 洋平", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/249389/original/c2f95d84-c781-4c2d-8a6c-4acddf4ed0dd.png?1487663471", 156],
  ["Kento Moriwaki", "森脇 健斗", nil, 75],
  ["Ryo Sakaguchi", "坂口 諒", nil, 99],
  ["Rina Takase", "Rina  Takase", nil, 54],
  ["Kodai Nakamura", "中村 高大", nil, 52],
  ["Mina Koguchi", nil, "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/1221562/original/4dcb1b8f-e728-417a-88fa-29f2dffc3c78.png?1491695897", 6],
  ["Naoyoshi Aikawa", "相川 直視", nil, 115],
  ["Shinichi Goto", "後藤 慎一", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/218236/original/0466d7bd-b4cb-4d5e-af99-246d4138d91a.png?1486216092", 108],
  ["Naomichi Agata", "縣 直道", nil, 19],
  ["Anton Van Eechaute", nil, "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/539368/original/9fb598fe-1684-4714-94fc-2a3a82b6cbec.png?1472355504", 78],
  ["Kodai Sakabe", "坂部 広大", nil, 81],
  ["Yu Tawata", "多和田 侑", nil, 37],
  ["Shuma Yoshioka", "吉岡 秀馬", nil, 74],
  ["Yuki Takemoto", "竹本 雄貴", nil, 58],
  ["Shimpei Otsubo", "大坪 新平", nil, 75],
  ["Masahiro Takigawa", "滝川 真弘", nil, 90],
  ["Jenko Wantedly", "Jenko Wantedly", nil, 6],
  ["Saito Yuichi", "齋藤 悠一", nil, 32],
  ["Shingo Tomioka", "富岡 真悟", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/848375/original/bf4fbd40-7e10-445c-8b5a-d6b3739799b2.png?1480333036", 60],
  ["Yuki Yamada", "山田 悠暉", "https://d2v9k5u4v94ulw.cloudfront.net/assets/images/1193266/original/b8a778a8-373e-48d9-b712-082ae995bb05.jpeg?1486028868", 66],
]

company = Company.find_by(name: 'Wantedly')
users.each do |name_en, name_ja, url, score|
  user = User.new
  user.name_en = name_en
  user.name_ja = name_ja
  user.score = score
  user.save!

  if url
    avatar = user.build_avatar
    avatar.url = url
    avatar.file_width = rand(100)
    avatar.file_height = rand(100)
    avatar.save!
  end

  company.jobs.create!(user_id: user.id)
end
