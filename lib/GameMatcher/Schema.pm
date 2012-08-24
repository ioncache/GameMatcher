use utf8;
package GameMatcher::Schema;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_components(qw< TimeStamp >);

__PACKAGE__->load_namespaces;

1;
