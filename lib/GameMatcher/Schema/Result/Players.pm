use utf8;
package GameMatcher::Schema::Result::Players;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('players');

__PACKAGE__->add_columns(
    'id' => {
        'data_type'         => 'integer',
        'is_auto_increment' => 1,
        'is_nullable'       => 0,
    },

    'email' => {
        'data_type'   => 'varchar',
        'size'        => 255,
        'is_nullable' => 1
    },

    'password' => {
        'data_type'   => 'varchar',
        'size'        => 255,
        'is_nullable' => 1
    },

    'name' => {
        'data_type'   => 'varchar',
        'size'        => 255,
        'is_nullable' => 1
    },

    'nickname' => {
        'data_type'   => 'varchar',
        'size'        => 255,
        'is_nullable' => 1
    },

    'avatar' => {
        'data_type'   => 'varchar',
        'size'        => 255,
        'is_nullable' => 1
    },    

    'created' => {
        'data_type'     => 'timestamp',
        'set_on_create' => 1,
        'is_nullable'   => 0,
    },

    'last_login' => {
        'data_type'     => 'timestamp',
        'set_on_update' => 1,
        'is_nullable'   => 0,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    PlayerGames => 'GameMatcher::Schema::Result::PlayerGames',
    { 'foreign.player' => 'self.id' }
);

__PACKAGE__->has_many(
    PlayerExpansions => 'GameMatcher::Schema::Result::PlayerExpansions',
    { 'foreign.player' => 'self.id' }
);

__PACKAGE__->has_many( MatchesPlayers => 'GameMatcher::Schema::Result::MatchesPlayers', 'player' );
__PACKAGE__->many_to_many( Matches => 'MatchesPlayers', 'match' );

1;
