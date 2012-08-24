use utf8;
package GameMatcher::Schema::Result::Matches;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('matches');

__PACKAGE__->add_columns(
    'id' => {
        'data_type'         => 'integer',
        'is_auto_increment' => 1,
        'is_nullable'       => 0,
    },

    'start_time' => {
        'data_type'     => 'timestamp',
        'set_on_update' => 1,
        'is_nullable'   => 0,
    },

    'location' => {
        'data_type'   => 'varchar',
        'size'        => 255,
        'is_nullable' => 1
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many( MatchesPlayers => 'GameMatcher::Schema::Result::MatchesPlayers', 'match' );
__PACKAGE__->many_to_many( Players => 'MatchesPlayers', 'player' );

1;
