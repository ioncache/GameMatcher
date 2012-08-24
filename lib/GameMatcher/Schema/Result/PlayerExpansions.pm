use utf8;
package GameMatcher::Schema::Result::PlayerExpansions;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('player_expansions');

__PACKAGE__->add_columns(
    'id' => {
        'data_type'         => 'integer',
        'is_auto_increment' => 1,
        'is_nullable'       => 0,
    },

    'expansion' => {
        'data_type'         => 'integer',
        'is_nullable'       => 0,
    },

    'player' => {
        'data_type'         => 'integer',
        'is_nullable'       => 0,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    Expansion => 'GameMatcher::Schema::Result::Expansions',
    { 'foreign.id' => 'self.expansion' },
);

__PACKAGE__->belongs_to(
    Player => 'GameMatcher::Schema::Result::Players',
    { 'foreign.id' => 'self.player' },
);

1;
