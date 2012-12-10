use utf8;
package GameMatcher::Schema::Result::Expansions;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw< TimeStamp >);

__PACKAGE__->table('expansions');

__PACKAGE__->add_columns(
    'id' => {
        'data_type'         => 'integer',
        'is_auto_increment' => 1,
        'is_nullable'       => 0,
    },

    'game' => {
        'data_type'   => 'integer',
        'is_nullable' => 0,
    },

    'name' => {
        'data_type'   => 'varchar',
        'size'        => 255,
        'is_nullable' => 1
    },

    'min_players' => {
        'data_type'   => 'integer',
        'is_nullable' => 0,
    },

    'max_players' => {
        'data_type'   => 'integer',
        'is_nullable' => 0,
    },

    'optimal_players' => {
        'data_type'   => 'varchar',
        'size'        => 255,
        'is_nullable' => 0,
    },

    'playtime' => {
        'data_type'   => 'integer',
        'is_nullable' => 0,
    },

    'description' => {
        'data_type'   => 'text',
        'is_nullable' => 0,
    },

    'created' => {
        'data_type'     => 'timestamp',
        'set_on_create' => 1,
        'is_nullable'   => 0,
    },

);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    Game => 'GameMatcher::Schema::Result::Games',
    { 'foreign.id' => 'self.game' },
);

__PACKAGE__->has_many(
    PlayerExpansions => 'GameMatcher::Schema::Result::PlayerExpansions',
    { 'foreign.expansion' => 'self.id' }
);

1;
