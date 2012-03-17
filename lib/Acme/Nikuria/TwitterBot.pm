package Acme::Nikuria::TwitterBot;
use strict;
use utf8;
use warnings;

use Acme::Nikuria;
use AnyEvent;
use AnyEvent::Twitter::Stream;
use Net::Twitter;

# - %args = (
#       consumer_key,
#       consumer_secret,
#       access_token,
#       access_token_secret,
#   )
sub new {
    my ($class, %args) = @_;
    my $tw = Net::Twitter->new(
        traits => [qw(OAuth API::REST)],
        %args,
    );
    my $self = {
        args => { map {
            my $key = $_;
            my $value = $args{$key};
            $key =~ s/^access_//;
            ($key => $value);
        } keys %args },
        twitter => $tw,
    };
    bless $self, $class;
    $self->_connect;
    return $self;
}

sub _connect {
    my ($self) = @_;
    $self->{stream} //= AnyEvent::Twitter::Stream->new(
        %{ $self->{args} },
        method   => 'userstream',
        on_error => sub {
            undef $self->{stream};
            $self->_connect;
        },
        on_friends => sub { },
        on_event   => sub { },
        on_delete  => sub { },
        on_tweet   => sub {
            my ($tweet) = @_;
            my $text = $tweet->{text};
            if ($text =~ s/^\@acmenikuria\s+//) {
                my ($res, $message, $matched) = Acme::Nikuria->_call($text);
                my $id = $tweet->{id};
                my $mention_to = $tweet->{user}->{screen_name};
                my $update = "\@$mention_to ";
                if ($matched) {
                    $update .= "${matched}は";
                    $update .= ($res ? '肉です。' : '肉じゃないです。');
                }
                $update .= $message;
                $self->{twitter}->update($update, {
                    in_reply_to_status_id => $id,
                });
            }
        },
    );
}

1;
__END__


=head1 NAME

Acme::Nikuria::TwitterBot - nikuria twitter bot

=head1 SYNOPSIS

  use Acme::Nikuria::TwitterBot;
  use AnyEvent;

  my $cv = AnyEvent->condvar;
  my $bot = Acme::Nikuria::TwitterBot->new(
      consumer_key        => 'you app consumer_key',
      consumer_secret     => 'yout app consumer_secret',
      access_token        => "your nikuria account's access_token",
      access_token_secret => "your nikuria account's access_token_secret",
  );
  $cv->recv;

=cut
