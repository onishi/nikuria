package Acme::Nikuria;
use strict;
use warnings;

use parent qw/Class::Accessor::Fast/;
use utf8;
use Encode;

our $niku = {
    qr/焼き肉/ => '自分で焼いてこそ肉です。 ',
    qr/ブロック肉|ステーキ/ => 'ブロック肉ならお肉です。',
};

our $nikujanai = {
    qr/ケンタッキー|カツ|唐揚げ|フライ/ => '唐揚げジャンルです。',
    qr/ささみ|タタキ|マリネ/ => '刺身です。',
    qr/酢豚/ => '野菜炒めです。',
    qr/鶏肉/ => 'じゃがいもです。',
    qr/砂ずり/ => 'イカかタコです。',
    qr/牛丼/ => 'しぐれてますね。',
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

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
