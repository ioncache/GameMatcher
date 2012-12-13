#!/usr/bin/env perl

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

#$schema->deploy;
#
#say "done deploy";

#my $players = $schema->resultset('GameMatcher::Schema::Result::Players');
#
#say "done resultset";
#
#my $new_player = $players->create(
#    {   email    => 'markj@oanda.com',
#        name     => 'Mark Jubenville',
#        nickname => 'ioncache_' . time,
#    }
#);
#
#say "done creating player";
#
#say $new_player->name;

my $matches = $schema->resultset('GameMatcher::Schema::Result::Matches')->search({}, { order_by => 'start_time DESC' })->all();

p $matches;