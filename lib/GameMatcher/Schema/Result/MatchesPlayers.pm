use utf8;
package GameMatcher::Schema::Result::MatchesPlayers;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('matches_players');

__PACKAGE__->add_columns(
    'id' => {
        'data_type'         => 'integer',
        'is_auto_increment' => 1,
        'is_nullable'       => 0,
    },

    'match' => {
        'data_type'         => 'integer',
        'is_nullable'       => 0,
    },

    'player' => {
        'data_type'         => 'integer',
        'is_nullable'       => 0,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(player => 'GameMatcher::Schema::Result::Players');

__PACKAGE__->belongs_to(match => 'GameMatcher::Schema::Result::Matches');

1;
