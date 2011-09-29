#!perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Acme::Nikuria;
use Perl6::Say;
use utf8;

binmode STDOUT, ':utf8';

for my $str (qw/ささみ トンカツ トマト煮に入ってる鶏肉 焼き肉 牛丼 大西 cho45 motemen/) {
    say(Acme::Nikuria->call($str));
}

# ささみは肉じゃないです。刺身です。
# トンカツは肉じゃないです。唐揚げジャンルです。
# トマト煮に入ってる鶏肉は肉じゃないです。じゃがいもです。
# 焼き肉は肉です。自分で焼いてこそ肉です。 
# 牛丼は肉じゃないです。しぐれてますね。
# 大西は肉じゃないです。切っちゃうとダメなんです。
# cho45は肉じゃないです。色がちょっと…
# motemenは肉じゃないです。私、お肉に対する理想が高いんですかね。

