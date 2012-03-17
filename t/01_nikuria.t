use strict;
use warnings;
use utf8;

use Test::Base;

use Acme::Nikuria;

plan tests => 2 * blocks;

filters {
    food    => 'chomp',
    is_niku => 'chomp',
    call    => 'chomp',
};

run {
    my $block = shift;
    my $food = $block->food;
    is(Acme::Nikuria->is_niku($food), $block->is_niku);
    is(Acme::Nikuria->call($food), $block->call);
};

__DATA__

===
--- food
焼き肉
--- is_niku
1
--- call
焼き肉は肉です。自分で焼いてこそ肉！お肉の中のお肉です。

===
--- food
トンカツ
--- is_niku
0
--- call
トンカツは肉じゃないです。揚げ物ジャンルです。

===
--- food
ささみはお肉ですか
--- is_niku
0
--- call
ささみは肉じゃないです。野菜です。
