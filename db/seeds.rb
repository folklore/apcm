# -*- encoding : utf-8 -*-

City.create([{ name: 'Чикаго' },
             { name: 'Копенгаген' },
             { name: 'Екатеринбург' }])

names = %w{Бронислав Владислав Вячеслав Мирослав Мстислав Святослав Славомир Станислав Радислав Ростислав Ярослав Чеслав Доброслав Венцеслав Велислав}

names.each do |name|
  User.create(name: name,
              email: "#{Russian::transliterate(name).downcase}@gmail.com",
              city_id: rand(3) + 1)
end

admin = User.where(email: 'stanislav@gmail.com')
            .first
admin.update_attributes({is_admin: true, city_id: 3}, as: :admin)

text = 'На краю дороги стоял дуб. Вероятно, в десять раз старше берез, составлявших лес, он был в десять раз толще, и в два раза выше каждой березы. Это был огромный, в два обхвата дуб, с обломанными, давно, видно, суками и с обломанной корой, заросшей старыми болячками. С огромными своими неуклюже, несимметрично растопыренными корявыми руками и пальцами, он старым, сердитым и презрительным уродом стоял между улыбающимися березами. Только он один не хотел подчиняться обаянию весны и не хотел видеть ни весны, ни солнца. «Весна, и любовь, и счастие! — как будто говорил этот дуб. — И как не надоест вам все один и тот же глупый бессмысленный обман! Все одно и то же, и все обман! Нет ни весны, ни солнца, ни счастья. Вон смотрите, сидят задавленные мертвые ели, всегда одинакие, и вон и я растопырил свои обломанные, ободранные пальцы, где ни выросли они — из спины, из боков. Как выросли — так и стою, и не верю вашим надеждам и обманам». Князь Андрей несколько раз оглянулся на этот дуб, проезжая по лесу, как будто он чего-то ждал от него. Цветы и трава были и под дубом, но он все так же, хмурясь, неподвижно, уродливо и упорно, стоял посреди их. «Да, он прав, тысячу раз прав этот дуб, — думал князь Андрей, — пускай другие, молодые, вновь поддаются на этот обман, а мы знаем жизнь, — наша жизнь кончена! » Целый новый ряд мыслей безнадежных, но грустно-приятных в связи с этим дубом возник в душе князя Андрея. Во время этого путешествия он как будто вновь обдумал всю свою жизнь и пришел к тому же прежнему, успокоительному и безнадежному, заключению, что ему начинать ничего было не надо, что он должен доживать свою жизнь, не делая зла, не тревожась и ничего не желая.'

length = text.length
truncated_length = length - 150

(names.size * 20).times do |i|
  position_title = rand(truncated_length)
  position_content = rand(truncated_length)

  Note.create(user_id: rand(names.size) + 1,
              title: text[position_title..position_title+25],
              content: text[position_content..position_content+150],
              status: 'pending',
              created_at: DateTime.now - rand(10).days - rand(10).hours)
end

statuses = %w{pending active deleted}

Note.all.each do |note|
  note.update_attributes(status: statuses.shuffle.first,
                         updated_at: note.created_at + rand(10).days + rand(10).hours)
end