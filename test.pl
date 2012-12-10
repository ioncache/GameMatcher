#!/usr/bin/env perl

use Modern::Perl;

use Data::Printer;

use GameMatcher::Schema;

my $schema = GameMatcher::Schema->connect(
    'dbi:SQLite:dbname=game_matcher.sqlite',
    '', '', 
    { RaiseError => 1, AutoCommit => 1 }
);

#$schema->deploy;

my $players = $schema->resultset('Players');

my $new_player = $players->create(
    {   email    => 'markj@oanda.com',
        name     => 'Mark Jubenville',
        nickname => 'ioncache',
    }
);

p $new_player;

