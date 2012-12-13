package GameMatcher;

use Modern::Perl;

use Data::Printer;

use GameMatcher::Schema;

my $schema = GameMatcher::Schema->connect(
    'dbi:SQLite:dbname=db/game_matcher.sqlite',
    '',
    '', 
    {
        AutoCommit => 1,
        RaiseError => 1,
        on_connect_call => 'use_foreign_keys',
    }
);

1;
