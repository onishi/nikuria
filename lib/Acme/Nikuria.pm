package Acme::Nikuria;
use strict;
use warnings;

use parent qw/Class::Accessor::Fast/;
use utf8;
use Encode;

our $niku = {
    qr/焼き肉/ => '自分で焼いてこそ肉です。 ',
    qr/ブロック肉|ステーキ|スペアリブ|骨付き肉/ => 'ブロック肉ならお肉です。',
    qr/角煮/ => '肉感があるじゃないですか。',
    qr/ハンバーグ/ => '肉かな…',
    qr/ジンギスカン/ => 'めっちゃ敷き詰めてますね！',
    qr/牛タン/ => '好きだから肉です。',
    qr/ハラミ/ => '',
};

our $nikujanai = {
    qr/ケンタッキー|カツ|唐揚げ|フライ/ => '唐揚げジャンルです。',
    qr/タタキ|マリネ|ユッケ/ => '刺身です。',
    qr/ささみ|棒々鶏|しゃぶ/ => '野菜です。',
    qr/チキン南蛮/ => 'メインにはならない。',
    qr/青椒肉絲/ => 'ピーマンです。',
    qr/竜田揚げ/ => '魚じゃないんですか。',
    qr/豚肉/ => '肉とは言いがたい。',
    qr/酢豚/ => '野菜炒めです。',
    qr/鶏肉/ => 'じゃがいもです。',
    qr/砂ずり/ => 'イカかタコです。',
    qr/牛丼/ => 'しぐれてますね。',
    qr/ハム/ => 'ハムですね！',
    qr/魚/ => '前菜。',
};

our $fallback = [qw/
    色がちょっと…
    私、お肉に対する理想が高いんですかね。
    切っちゃうとダメなんです。
/];

sub _call {
    my ($class, $str) = @_;
    defined $str or $str = '';
    $str = Encode::decode('utf-8', $str) unless Encode::is_utf8($str);
    for my $ng (sort {length($b) <=> length($a)} keys %$nikujanai) {
        if ($str =~ $ng) {
            return (0, $nikujanai->{$ng});
        }
    }
    for my $ok (sort {length($b) <=> length($a)} keys %$niku) {
        if ($str =~ $ok) {
            return (1, $niku->{$ok});
        }
    }
    return (0, $fallback->[ord(substr($str || '0', 0, 1)) % @$fallback]);
}

sub is_niku {
    my ($class, $str) = @_;
    my ($res, $message) = $class->_call($str);
    $res;
}

sub call {
    my ($class, $str) = @_;
    my ($res, $message) = $class->_call($str);
    sprintf '%s%s。%s', ($str ? $str."は" : '') , ($res ? '肉です' : '肉じゃないです'), $message;
}

1;

__END__


=head1 NAME

Acme::Nikuria - nikuria api

=head1 SYNOPSIS

  use Acme::Nikuria;

  for my $str (qw/ささみ トンカツ 焼き肉/) {
      print Acme::Nikuria->call($str);
  }

=head1 AUTHOR

Yasuhiro Onishi E<lt>yasuhiro.onishi@gmail.comE<gt>

=head1 SEE ALSO

<http://shindanmaker.com/155104>.
<http://togetter.com/li/193740>.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
