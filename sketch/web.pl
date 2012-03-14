#!/usr/env perl 
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use utf8;

{
    package NikuServer;

    use HTTP::Server::Simple::CGI;
    use base qw(HTTP::Server::Simple::CGI);
    use Template;
    use Acme::Nikuria;

    sub handle_request {
        my $self = shift;
        my $q  = shift;
        my $req = $q->param('niku');
        utf8::decode($req);

        my $res = Acme::Nikuria->call($req);

        print "HTTP/1.0 200 OK\r\n";
        print $q->header(-charset=>"utf-8");
        my $template = Template->new(
            VARIABLES => {
                req => $req,
                res => $res,
            }
        );
        my $output;
        my $t = qq{
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Acme::Nikuria</title>
</head>
<body>
<form action="/">
肉だと思うものを入力してください：<input type="text" name="niku" value="[% req | html %]" /><input type="submit" value="判定" />
[%- IF req %]
<p>
[%- res | html -%]
</p>
[% END %]
</form>
</body>
</html>
        };
        $template->process(\$t, undef, \$output);
        print $output;
    }
} 

NikuServer->new()->run();

