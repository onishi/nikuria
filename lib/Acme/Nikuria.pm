package Acme::Nikuria;
use strict;
use warnings;

use parent qw/Class::Accessor::Fast/;
use utf8;
use Encode;

our $niku = {
    qr/焼き肉/ => '自分で焼いてこそ肉！お肉の中のお肉です。',
    qr/ブロック肉|ステーキ|スペアリブ|骨付き肉/ => '塊感あるのでお肉です。',
    qr/角煮/ => '肉感があるじゃないですか。でも物による場合もあります。',
    qr/ジンギスカン/ => 'めっちゃ敷き詰めてますね！文化的にあうのかもしれません。',
    qr/牛タン|しゃぶしゃぶ/ => '好きだからお肉です。',
    qr/ハラミ/ => 'お肉です。',
};

our $nikujanai = {
    qr/ケンタッキー|唐揚げ/ => '唐揚げジャンルです。',
    qr/フライ|トンカツ/ => '揚げ物ジャンルです。',
    qr/タタキ|マリネ|ユッケ/ => '刺身です。',
    qr/ささみ|棒々鶏|冷しゃぶ/ => '野菜です。',
    qr/チキン南蛮/ => 'メインにはならないです。',
    qr/青椒肉絲/ => '色的にピーマンのほうが目立ってますよね…。',
    qr/竜田揚げ/ => '魚っぽくないですか？',
    qr/豚肉/ => '肉とは言いがたい。',
    qr/酢豚/ => '野菜炒めです。',
    qr/鶏肉/ => 'じゃがいもです。',
    qr/砂ずり/ => 'イカかタコです。',
    qr/牛丼/ => 'しぐれてますね。',
    qr/ハム/ => 'ハムですね！',
    qr/魚/ => '前菜です。',
    qr/ハンバーグ/ => 'ミンチにするとお肉じゃなくなります！',
    qr/くじら肉/ => 'くじらのことはどう頑張ってもお肉とは思えません…',
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
        if ($str =~ qr/($ng)/) {
            my $matched = $1;
            return (0, $nikujanai->{$ng}, $matched);
        }
    }
    for my $ok (sort {length($b) <=> length($a)} keys %$niku) {
        if ($str =~ qr/($ok)/) {
            my $matched = $1;
            return (1, $niku->{$ok}, $matched);
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
    my ($res, $message, $matched) = $class->_call($str);
    sprintf '%s%s。%s', ($matched || $str) . "は", ($res ? '肉です' : '肉じゃないです'), $message;
}

1;

__END__


=head1 NAME

Acme::Nikuria - nikuria api

=head1 SYNOPSIS

  use Acme::Nikuria;

  Acme::Nikuria->is_niku($food);
  Acme::Nikuria->call($food);

=head1 DESCRIPTION

Acme::Nikuria is api determine whether niku (meat) or not.

  use Acme::Nikuria;

  for (qw/ささみ トンカツ 焼き肉/) {
      print Acme::Nikuria->call($_);
  }

Output as follows.

  ささみは肉じゃないです。刺身です。
  トンカツは肉じゃないです。唐揚げジャンルです。
  焼き肉は肉です。自分で焼いてこそ肉です。

=head1 AUTHOR

Yasuhiro Onishi E<lt>yasuhiro.onishi@gmail.comE<gt>

=head1 SEE ALSO

=over

=item <http://shindanmaker.com/155104>

=item <http://togetter.com/li/193740>

=back

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
