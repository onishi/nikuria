use lib 'lib';
use Acme::Nikuria;

my $app = sub {
    my $env = shift;
    (my $food = $env->{PATH_INFO}) =~ s{/}{}g;
    my ($code, $message) = Acme::Nikuria->_call($food);
    return [
        $code ? '200' : '500',
        [ 'Content-Type' => 'text/plain; charset=utf-8' ],
        [ Encode::encode('utf-8', $message) ],
    ];
};
