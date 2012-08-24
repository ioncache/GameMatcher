package GameMatcher;
use Dancer ':syntax';

get '/' => sub {
    template 'index';
};

true;
