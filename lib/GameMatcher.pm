package GameMatcher;

use Dancer ':syntax';
#use Dancer::Plugin::Resource;

get '/' => sub {
    template 'index';
};

true;
