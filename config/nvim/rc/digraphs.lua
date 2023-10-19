local digraphs = vim.cmd.digraphs

-- 括弧のdigraphsをいっぱい定義していてカッコいい
digraphs("j(", 65288) -- （
digraphs("j)", 65289) -- ）
digraphs("j[", 12300) -- 「
digraphs("j]", 12301) -- 」
digraphs("j{", 12302) -- 『
digraphs("j}", 12303) -- 』
digraphs("j<", 12304) -- 【
digraphs("j>", 12305) -- 】

-- 句読点
digraphs("j,", 12289) -- 、
digraphs("j.", 12290) -- 。
digraphs("j!", 65281) -- ！
digraphs("j?", 65311) -- ？
digraphs("j:", 65311) -- ：

-- 数字
digraphs("j0", 65296) -- ０
digraphs("j1", 65297) -- １
digraphs("j2", 65298) -- ２
digraphs("j3", 65299) -- ３
digraphs("j4", 65300) -- ４
digraphs("j5", 65301) -- ５
digraphs("j6", 65302) -- ６
digraphs("j7", 65303) -- ７
digraphs("j8", 65304) -- ８
digraphs("j9", 65305) -- ９

-- その他の記号
digraphs("j~", 65374) -- ～
digraphs("j/", 12539) -- ・
digraphs("j ", 12288) -- 　
