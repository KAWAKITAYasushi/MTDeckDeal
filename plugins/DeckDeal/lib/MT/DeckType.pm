package MT::DeckType;
use strict;

use base qw( MT::Object );

__PACKAGE__->install_properties ({
    column_defs => {
        'id'          => 'integer not null auto_increment',
        'name'        => 'string(255) not null',
        'cardtype_id' => 'integer not null',
        'count'       => 'integer not null'.
        'setcount'    => 'integer not null'.
        'must'        => 'text',
        'nouse'       => 'text',
    },
    indexes => {
        cardtype_id => 1,
        created_on => 1,
        modified_on => 1,
    },
    audit => 1,
    datasource  => 'decktype',
    primary_key => 'id',
    class_type  => 'decktype',
});
