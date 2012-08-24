use utf8;
package GameMatcher::Schema::Result::PlayerGames;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('player_games');

__PACKAGE__->add_columns(
    'id' => {
        'data_type'         => 'integer',
        'is_auto_increment' => 1,
        'is_nullable'       => 0,
    },

    'game' => {
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
    Game => 'GameMatcher::Schema::Result::Games',
    { 'foreign.id' => 'self.game' },
);

__PACKAGE__->belongs_to(
    Player => 'GameMatcher::Schema::Result::Players',
    { 'foreign.id' => 'self.player' },
);

1;
